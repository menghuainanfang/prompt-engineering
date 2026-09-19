"""Optional local OCR. Prints JSON; never edits the image or learning archive."""
import argparse
import json
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('image', type=Path)
    args = parser.parse_args()
    try:
        if not args.image.is_file():
            raise ValueError('Image file does not exist')
        from PIL import Image
        with Image.open(args.image) as im:
            width, height = im.size
            im.verify()
        if width * height > 40_000_000:
            raise ValueError('Image exceeds 40 megapixels; split into page regions first')
        from rapidocr_onnxruntime import RapidOCR
        engine = RapidOCR(intra_op_num_threads=2, inter_op_num_threads=2)
        result, _ = engine(str(args.image.resolve()))
        lines = [{'text': row[1], 'confidence': float(row[2]), 'box': row[0]} for row in (result or [])]
        payload = {'status': 'ok' if lines else 'no_text', 'engine': 'rapidocr_onnxruntime',
                   'size': [width, height], 'text': '\n'.join(row['text'] for row in lines), 'lines': lines,
                   'limitations': 'Verify punctuation and formulas against the image. No handwriting or formula-to-LaTeX guarantee.'}
        print(json.dumps(payload, ensure_ascii=False))
        return 0 if lines else 2
    except Exception as exc:
        print(json.dumps({'status': 'error', 'error_type': type(exc).__name__, 'message': str(exc)}, ensure_ascii=False))
        return 1


if __name__ == '__main__':
    sys.exit(main())
