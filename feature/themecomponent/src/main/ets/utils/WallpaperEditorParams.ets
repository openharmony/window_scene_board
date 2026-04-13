/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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