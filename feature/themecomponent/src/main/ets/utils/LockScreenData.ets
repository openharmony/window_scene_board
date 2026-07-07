import { WallpaperQualifier } from "./WallpaperWriter";

export class LockScreenData {
  public qualifier: WallpaperQualifier;

  constructor (qualifier: WallpaperQualifier) {
    this.qualifier = qualifier;
  }
}