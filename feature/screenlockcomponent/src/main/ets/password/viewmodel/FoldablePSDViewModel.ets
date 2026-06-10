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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, ScreenOrientation, ScreenStateMonitor } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import ScreenLockKeyboardTipUtil from '../../common/ScreenLockKeyboardUtil';
import { display } from '@kit.ArkUI';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  SlMainStateType, SlSubStateType, SlStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import {
  DisplayUtils,
  ISlStateChangeListener
} from '@ohos/screenlockcommon';
import { DisplayStateListener, DisplayStateManager } from '@ohos/screenlockcommon/Index';
import { ScreenBp } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { SizeBreakPoint } from '@ohos/screenlockcommon/src/main/ets/constants/ScreenBreakPoint';

const TAG = 'FoldablePSDViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const IS_ULTRA_SCREEN: boolean = DeviceHelper.isUltraScreenProduct();

export class FoldablePSDModel {
  // 是否是超大屏G态
  @Track public isUltraScreenGState: boolean = false;
  // 是否是超大屏G态且横屏
  public isUltraScreenGStateLandscape: boolean = false;
  // 超大屏G密码盘宽度占比
  @Track public gStateKeyboardWidthPercent: number = 0.5;
  // 是否展开
  @Track public isExpand: boolean = false;
}

export default class FoldablePSDViewModel {
  public foldablePSDModel: FoldablePSDModel = new FoldablePSDModel();

  private updateUltraScreenGState: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SCREEN_BP) {
        const isGState: boolean = DisplayUtils.isUltraScreenGStatus();
        this.foldablePSDModel.isUltraScreenGState = isGState;
        if (isGState) {
          const bpState: ScreenBp = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.
            getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
          this.foldablePSDModel.isUltraScreenGStateLandscape = bpState.heightBp === SizeBreakPoint.SM;
        }
        this.updateUltraScreenGStateParam();
      }
    }
  }

  private displayStateListener: DisplayStateListener = {
    onFoldStatusChange: (foldStatus: number): void => {
      this.foldablePSDModel.isExpand = this.isPasswordExpand(foldStatus);
    },
  };

  viewModelInit(foldablePSDModel: FoldablePSDModel) {
    this.foldablePSDModel = foldablePSDModel;
  }

  doInit(): void {
    log.showInfo('doInit');
    if (IS_ULTRA_SCREEN) {
      this.foldablePSDModel.isUltraScreenGState = DeviceHelper.isGState();
      this.foldablePSDModel.isUltraScreenGStateLandscape = this.foldablePSDModel.isUltraScreenGState &&
        ScreenStateMonitor.getInstance().getCurrentScreenStateModel().orientation === ScreenOrientation.LANDSCAPE;
      slUiStateMgr.registerSlStateChangeListener(this.updateUltraScreenGState);
      this.updateUltraScreenGStateParam();
    }
    this.foldablePSDModel.isExpand = this.isPasswordExpand(DisplayUtils.getFoldStatus());
    DisplayStateManager.getInstance().registerObserver(this.displayStateListener);
  }

  doRelease(): void {
    log.showInfo('doRelease');
    if (IS_ULTRA_SCREEN) {
      slUiStateMgr.unregisterSlStateChangeListener(this.updateUltraScreenGState);
    }
    DisplayStateManager.getInstance().unRegisterObserver(this.displayStateListener);
  }

  private updateUltraScreenGStateParam() {
    if (this.foldablePSDModel.isUltraScreenGState) {
      log.showInfo(`isUltraScreenGState, isUltraScreenGStateLandscape:${this.foldablePSDModel.isUltraScreenGStateLandscape}`);
      let displayWidth: number = 0;
      try {
        displayWidth = px2vp(display.getDefaultDisplaySync().width);
      } catch (error) {
        log.showError('updateUltraScreenGStateParam getDefaultDisplaySync fail');
        return;
      }
      this.foldablePSDModel.gStateKeyboardWidthPercent =
        ScreenLockKeyboardTipUtil.getGStateKeyboardWidthPercent(displayWidth,
          this.foldablePSDModel.isUltraScreenGStateLandscape);
    }
  }

  /**
   * 密码是否展开显示
   *
   * @param foldStatus 折叠状态
   * @returns true, 展开显示
   */
  private isPasswordExpand(foldStatus: number | display.FoldStatus): boolean {
    return foldStatus !== display.FoldStatus.FOLD_STATUS_UNKNOWN &&
      foldStatus !== display.FoldStatus.FOLD_STATUS_FOLDED &&
      foldStatus !== display.FoldStatus.FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED &&
      foldStatus !== display.FoldStatus.FOLD_STATUS_FOLDED_WITH_SECOND_HALF_FOLDED;
  }
}
