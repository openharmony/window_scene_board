
export interface AnyRectInterface {
  x: number,
  y: number,
  width: number,
  height: number,
  ratio?: number,
}

@Observed
export class AnyRect {
  public x: number;
  public y: number;
  public width: number;
  public height: number;
  public ratio: number;

  constructor(params?: AnyRectInterface) {
    this.x = params?.x ?? -1;
    this.y = params?.y ?? -1;
    this.width = params?.width ?? 0;
    this.height = params?.height ?? 0;
    this.ratio = params?.ratio ?? 1.0;
  }

  public toString(): string {
    return `x=${this.x}, ` +
      `y=${this.y}, ` +
      `width=${this.width}, ` +
      `height=${this.height}, ` +
      `ratio=${this.ratio}, `;
  }
}