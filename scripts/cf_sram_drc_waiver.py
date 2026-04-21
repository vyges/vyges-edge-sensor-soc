#!/usr/bin/env python3
"""Post-process a KLayout lyrdb to waive DRC violations inside vendor SRAM cells.

Walks the GDS hierarchy to find all instances whose cellname matches PATTERN
(default CF_SRAM_*), computes their top-level-coord bounding boxes in microns,
then filters lyrdb violations whose full coordinate extent lies inside any
such bounding box. Violations straddling the cell boundary are kept, since
they represent integration-level issues that the vendor's own DRC deck did
not sign off.

Usage:
    cf_sram_drc_waiver.py GDS LYRDB_IN LYRDB_OUT [--pattern GLOB]
"""

import argparse
import fnmatch
import re
import sys

import pya


def collect_vendor_bboxes(gds_path, pattern):
    layout = pya.Layout()
    layout.read(gds_path)
    top = layout.top_cell()
    dbu = layout.dbu

    bboxes_um = []
    iterator = pya.RecursiveInstanceIterator(layout, top)
    while not iterator.at_end():
        element = iterator.current_inst_element()
        inst = element.inst()
        cell = layout.cell(inst.cell_index)
        if fnmatch.fnmatchcase(cell.name, pattern):
            trans = iterator.trans()
            bbox = cell.bbox().transformed(trans)
            bboxes_um.append(
                (bbox.left * dbu, bbox.bottom * dbu, bbox.right * dbu, bbox.top * dbu)
            )
        iterator.next()

    return bboxes_um


_NUM_RE = re.compile(r"-?\d+\.?\d*")


def violation_extent(item_xml):
    """Return (xmin, ymin, xmax, ymax) in um covering all coords in the item."""
    xs, ys = [], []
    for m in re.finditer(r"<value>([^<]+)</value>", item_xml):
        nums = [float(n) for n in _NUM_RE.findall(m.group(1))]
        xs.extend(nums[0::2])
        ys.extend(nums[1::2])
    if not xs:
        return None
    return (min(xs), min(ys), max(xs), max(ys))


def waived(extent, bboxes_um):
    if extent is None:
        return False
    xl, yl, xr, yt = extent
    for bl, bb, br, bt in bboxes_um:
        if xl >= bl and yl >= bb and xr <= br and yt <= bt:
            return True
    return False


def filter_lyrdb(lyrdb_in, lyrdb_out, bboxes_um):
    with open(lyrdb_in) as f:
        xml = f.read()

    first = xml.find("<item>")
    last = xml.rfind("</item>")
    if first == -1 or last == -1:
        sys.exit(f"No <item> blocks in {lyrdb_in}")
    prefix = xml[:first]
    suffix = xml[last + len("</item>"):]
    body = xml[first:last + len("</item>")]

    items = re.findall(r"<item>.*?</item>", body, re.DOTALL)
    kept = [item for item in items if not waived(violation_extent(item), bboxes_um)]
    waived_count = len(items) - len(kept)

    with open(lyrdb_out, "w") as f:
        f.write(prefix)
        f.write("\n  ".join(kept))
        f.write(suffix)

    return len(items), waived_count, len(kept)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("gds")
    parser.add_argument("lyrdb_in")
    parser.add_argument("lyrdb_out")
    parser.add_argument("--pattern", default="CF_SRAM_*",
                        help="fnmatch pattern for vendor cell names (default: CF_SRAM_*)")
    args = parser.parse_args()

    bboxes = collect_vendor_bboxes(args.gds, args.pattern)
    print(f"Vendor cells matching '{args.pattern}': {len(bboxes)} instance(s)")
    for bl, bb, br, bt in bboxes:
        print(f"  bbox um: ({bl:.3f}, {bb:.3f}) -> ({br:.3f}, {bt:.3f})")

    if not bboxes:
        sys.exit(f"No instances match pattern '{args.pattern}' in {args.gds}")

    total, w, kept = filter_lyrdb(args.lyrdb_in, args.lyrdb_out, bboxes)
    print(f"Violations total: {total}")
    print(f"Waived (inside vendor cell): {w}")
    print(f"Kept: {kept}")
    print(f"Wrote {args.lyrdb_out}")


if __name__ == "__main__":
    main()
