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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { localEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

import {
  EditModeUtils,
  FolderModel,
  LayoutViewModel
} from '../../TsIndex';
import { OpenFolderStyle } from '../model/OpenFolderStyle';

const TAG = 'OpenFolderStyleConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class OpenFolderStyleConfig {
  private static instance: OpenFolderStyleConfig;
  private openFolderStyle?: OpenFolderStyle;
  private compensateTranslateYInEditMode: number = 0;

  /**
   * get folder style config instance
   */
  static getInstance(): OpenFolderStyleConfig {
    if (!OpenFolderStyleConfig.instance) {
      OpenFolderStyleConfig.instance = new OpenFolderStyleConfig();
      OpenFolderStyleConfig.instance.initConfig();
    }
    return OpenFolderStyleConfig.instance;
  }

  /*
   * 初始化Config, 设置openFolderStyle对象
   *
   */
  public initConfig(): void {
    const openFolderLayoutInfo = FolderModel.getInstance().getFolderOpenLayout();
    const openResult = LayoutViewModel.getInstance().calculateOpenFolder(openFolderLayoutInfo, false);
    this.openFolderStyle = openResult.mOpenFolderStyle;
  }

  /*
   * 获取展开态布局对象
   *
   * @returns 当前状态下获取的对象
   */
  public getOpenFolderStyle(): OpenFolderStyle {
    return this.openFolderStyle ?? new OpenFolderStyle();
  }

  /*
  * 设置展开态编辑模式下的背板中心点,用于计算编辑模式下补偿偏移y
  *
  */
  public setEditModeBgCenterPointY(editModeBgCenterPointY: number): void {
    if (!this.openFolderStyle) {
      return;
    }
    let screenHeight = AppStorage.get('screenHeight') as number;
    let originCenterY = this.openFolderStyle.titleMarginTop +
      (screenHeight - this.openFolderStyle.indicatorBottom - this.openFolderStyle.titleMarginTop) / 2;
    let editModeOriginCenterY = screenHeight / 2 + (originCenterY - screenHeight / 2) * EditModeUtils.getDesktopScale();
    this.compensateTranslateYInEditMode = editModeBgCenterPointY - editModeOriginCenterY;
  }

  /*
 * 为了达到编辑模式居中的效果,获取编辑模式下补偿偏移y
 *
 * @returns 当前状态下获取的对象
 */
  public getCompensateTranslateYInEditMode(): number {
    return this.compensateTranslateYInEditMode;
  }

}