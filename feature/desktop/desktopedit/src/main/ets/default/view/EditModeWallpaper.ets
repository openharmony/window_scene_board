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

import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';
import { editModeManager, EditModeUtils, EditModeWallpaperState } from '@ohos/launchercommon';
import { EditModeWallpaperViewData } from '../data/EditModeWallpaperViewData';
import { editModeViewManager } from '../manager/EditModeViewManager';
import { baseStateMgr, DarkModeState, StateType } from '@ohos/systemuicommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'EditModeWallpaper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 编辑模式壁纸背景
 */
@Component
export default struct EditModeWallpaper {
  @State wallpaperState: EditModeWallpaperState = editModeManager.getEditModeWallpaperState();
  @State editModeWallpaperViewData: EditModeWallpaperViewData = editModeViewManager.getEditModeWallpaperViewData();
  @State @Watch('onDarkModeStateChange') darkModeState: DarkModeState = baseStateMgr
    .getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;

  private onDarkModeStateChange() {
    if (editModeManager.isInNormalMode()) {
      return;
    }
    log.showWarn(`DarkModeState change in editmode, isDarkMode: ${this.darkModeState.isDarkMode}`);
    let backgroundColor: string = EditModeUtils.getEditModeWallpaperColor(this.darkModeState.isDarkMode);
    editModeViewManager.getEditModeWallpaperViewData().setWallpaperBackgroundColor(backgroundColor);
  }

  build() {
    if (this.wallpaperState.isShowWallpaper()) {
      Row() {
      }
      .backgroundColor(this.editModeWallpaperViewData.getWallpaperBackgroundColor())
      .backgroundBlurStyle(BlurStyle.BACKGROUND_THICK, {
        policy: 1,
        scale: this.editModeWallpaperViewData.getWallpaperBackgroundBlurScale()
      }, { disableSystemAdaptation: true })
      .width(EditModeStyleConstants.PERCENTAGE_100)
      .height(EditModeStyleConstants.PERCENTAGE_100)
    }
  }
}