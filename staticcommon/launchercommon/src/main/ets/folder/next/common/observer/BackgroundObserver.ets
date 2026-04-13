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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import EditModeConstants from '../../../../utils/EditModeConstants';
import { editModeManager } from '../../../../editmode/model/EditModeManager';
import { FolderCommonUtil } from '../FolderCommonUtil';
import { BackgroundObserverImpl } from './BackgroundObserverImpl';
import { BaseObserver } from './BaseObserver';

const TAG: string = 'BackgroundObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹背板Observer
 */
@ObservedV2
export class BackgroundObserver extends BaseObserver implements BackgroundObserverImpl {
  @Trace public backgroundColor: ResourceColor | undefined = undefined;

  private _isFolderInDock: boolean = false;
  private _isSolidColor: boolean = SCBVisualEffectMgr.isFolderSolidColor();

  public init(isInDock: boolean): void {
    this._isFolderInDock = isInDock;
    log.showWarn(`init isInDock:${isInDock}`);
    this.backgroundColor = FolderCommonUtil.getFolderBgColor(this._isSolidColor, this._isFolderInDock);
  }

  updateByEditMode(isEditMode: boolean): void {
    if (this._isSolidColor) {
      return;
    }
    animateToImmediately({ curve: EditModeConstants.CHANGE_DESKMODE_CURVE }, () => {
      this.setBgOpacity(isEditMode);
    });
  }

  private setBgOpacity(isEditMode: boolean): void {
    if (isEditMode) {
      // 赋值为透明度动效的终点值
      this.opacity = 1 - editModeManager.getEditModeFolderViewData().getFolderBackgroundBlurOpacity();
    } else {
      this.opacity = 1;
    }
  }
}