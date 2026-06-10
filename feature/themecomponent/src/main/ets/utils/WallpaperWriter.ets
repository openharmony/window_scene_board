/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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