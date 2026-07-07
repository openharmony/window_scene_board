import { LockScreenData } from "./LockScreenData";
import { WallpaperRectData, WallpaperSourceType } from "./WallpaperUtils"

export interface IWallpaperEditorParams {
  imageURL?: string,
  imageRectDataArray?: WallpaperRectData[],
  lockScreenDataArray?: LockScreenData[],
  shouldSaveHistoryWallpaperData?: boolean,
  wallpaperSourceType?: WallpaperSourceType,
  imageOrigin?: string,
  imageId?: string,
  source?: string,
}

@Observed
export class WallpaperEditorParams {
  public imageURL?: string;
  public imageRectDataArray?: WallpaperRectData[];
  public lockScreenDataArray?: LockScreenData[];
  public shouldSaveHistoryWallpaperData?: boolean;
  public wallpaperSourceType?: WallpaperSourceType;
  public imageOrigin?: string = '';
  public imageId?: string = '';
  public source?: string = ''

  constructor(params?: IWallpaperEditorParams) {
    this.imageURL = params?.imageURL;
    this.imageRectDataArray = params?.imageRectDataArray;
    this.lockScreenDataArray = params?.lockScreenDataArray;
    this.shouldSaveHistoryWallpaperData= params?.shouldSaveHistoryWallpaperData;
    this.wallpaperSourceType = params?.wallpaperSourceType;
    this.imageOrigin = params?.imageOrigin;
    this.imageId = params?.imageId;
    this.source = params?.source;
  }
}