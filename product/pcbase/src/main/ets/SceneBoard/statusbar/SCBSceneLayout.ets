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
import { SCBSceneSessionManager, windowMgr } from '@ohos/windowscene';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { NormalPanelInfo, StatusBarPanelInfo, StatusBarPanelManager } from '../../common/manager/StatusBarPanelManager';

const TAG = 'SCBSystemSceneLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 二级菜单背景组件
 */
@Component
export struct SCBSystemSceneLayout {
  @BuilderParam builder: () => void;
  @State panelInfo: StatusBarPanelInfo | undefined = undefined;
  persistentId: number = 0;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  panelShadowOptions: ShadowOptions | undefined = undefined;
  private needShadow: boolean = false;
  isTrayPanel: boolean = false;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.panelInfo = StatusBarPanelManager.getInstance().createPanelInfo(this.persistentId, this.panelShadowOptions);
    // 设置状态栏二级菜单弹出不抢焦
    SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)
    ?.setExclusivelyHighlighted(false);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    StatusBarPanelManager.getInstance().deletePanelInfo(this.panelInfo);
  }

  @Builder
  systemSceneBg() {
    Column() {
      Column()
        .backgroundEffect({ radius: this.panelInfo?.isDark ? 120 : 100 })
        .backgroundColor((this.panelInfo as NormalPanelInfo)?.brightnessBaseColor)
        .backgroundBrightnessInternal(this.colorModeViewData.statusBarPanelOption)
        .border({
          radius: this.panelInfo?.panelRadius,
          width: this.panelInfo?.panelBorderWidth,
          color: this.panelInfo?.panelInsideBorderColor,
        })
        .width('100%')
        .height('100%')
    }
    .shadow(this.needShadow ? ShadowStyle.OUTER_DEFAULT_MD : undefined)
    .border({
      radius: this.panelInfo?.panelRadius,
      width: this.panelInfo?.panelBorderWidth,
      color: this.panelInfo?.panelOutsideBorderColor,
    })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      this.systemSceneBg()
      this.builder()
    }
    .onFocus(() => {
      log.showInfo(`onFocus, id :${this.persistentId}`);
    })
    .onBlur(() => {
      log.showInfo(`onBlur, id :${this.persistentId}`);
    })
  }

}
