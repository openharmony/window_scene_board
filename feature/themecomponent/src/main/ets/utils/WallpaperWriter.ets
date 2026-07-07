import { WallPaper } from "@ohos/themeservicekit";
import { image } from "@kit.ImageKit";


export interface WallpaperWriter {
  qualifier: WallpaperQualifier,
  wallpaperUrl?: string,
  desktopWallpaperModel: WallPaper,
  lockWallpaperModel: WallPaper,
  originWallpaperModel: WallPaper,
  desktopWallpaper?: image.PixelMap | string,
  unlockWallpaper?: image.PixelMap | string,
  originWallpaper?: image.PixelMap | string,
}


export enum WallpaperQualifier {
  BASE = 'BASE'
}