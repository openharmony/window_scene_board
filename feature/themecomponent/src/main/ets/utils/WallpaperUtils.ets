import { AnyRect } from "./AnyRect";
import { WallpaperQualifier } from "./WallpaperWriter";

export enum WallpaperSourceType {
  UNKNOWN,
  THEME,
  HISTORY,
  PHOTO,
  BACKUP,
  FILE,
}

export class WallpaperRectData {
  public qualifier: WallpaperQualifier;
  public rect: AnyRect;

  constructor(qualifier: WallpaperQualifier, rect: AnyRect) {
    this.qualifier = qualifier;
    this.rect = rect;
  }

  public toString(): string {
    return `qualifier=${this.qualifier}, ` + `rect=${this.rect.toString()}, `
  }
}