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

import curves from '@ohos.curves';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { EvtBus, obtainLocalEvent, sEventManager } from '@ohos/frameworkwrapper';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ScrollBlurController } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurController';
import { ControlCenterAnimatingEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import { SysApiWrapper } from '../common/SysApiWrapper';
import { ControlCenterHomeViewData } from '../vm/ControlCenterHomeViewData';
import Constants from '../common/Constants';
import { ControlCenterLayoutController, ControlCenterLayoutIndex } from '../controller/ControlCenterLayoutController';
import { QuickToggleController } from '../controller/QuickToggleController';

const TAG = 'ControlCenterHomeViewModel';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);
const DELAY_LOAD_EDIT_PAGE: number = 50;
const DELAY_SHOW_EDIT_PAGE: number = 350;
const ROW_SPACE: number = 16;

export class ControlCenterHomeViewModel {
  public viewData: ControlCenterHomeViewData;
  public uiExtProxy?: UIExtensionProxy;
  private scroller: Scroller;
  private isIotEditSupported: boolean = Constants.IS_IOT_EDIT_SUPPORTED;
  private isEditing: boolean = false;
  private loadEditTimerId: number = -1;
  private showEditTimerId: number = -1;
  private scrollBlurController?: ScrollBlurController;
  private isLargeFoldStyle: boolean = false;

  constructor(viewData: ControlCenterHomeViewData, scroller: Scroller) {
    this.viewData = viewData;
    this.scroller = scroller;
  }

  public setScrollBlurController(scrollBlurController: ScrollBlurController) {
    this.scrollBlurController = scrollBlurController;
  }

  public getIsEditing(): boolean {
    log.showInfo(`getIsEditing-isEditing:${this.isEditing}`);
    return this.isEditing;
  }

  public jumpToEditView = (): void => {
    TraceUtil.startTrace(DomainName.CC, 'jumpToEditView');
    log.showInfo('jumpToEditView');
    this.isEditing = true;
    EvtBus.post(ControlCenterAnimatingEvent, { controlCenterAnimating: true });
    this.viewData.blankLayoutWeight = 0;
    if (this.isIotEditSupported) {
      this.uiExtProxy?.send({ 'method': 'jumpToIotEdit' });
    }
    this.isLargeFoldStyle = this.getLargeFoldStyle();
    SysApiWrapper.animateTo({
      curve: Curve.Friction,
      duration: 350
    }, () => {
      this.viewData.mediaCardOpacity = 0;
      this.viewData.largeMediaCardOpacity = 0;
      this.viewData.largeMediaCardScale = 0.95;
      this.viewData.superTerminalOpacity = 0;
      this.viewData.focusOpacity = 0;
    });
    this.viewData.showAddMoreButton = true;
    // 如果进入编辑前头部有模糊，需要进入编辑后让它消失
    animateTo({
      curve: Curve.Friction,
      duration: 300
    }, () => {
      this.scrollBlurController?.inactiveScrollerBlur();
    })
    if (!this.scrollBlurController?.getBlurActiveState()) {
      this.viewData.shouldClipHeadArea = true;
      log.showInfo('no need show blur area, clip head');
    }
    SysApiWrapper.animateTo({
      curve: curves.interpolatingSpring(0, 1, 503, 45)
    }, () => {
      this.scroller.scrollTo({
        xOffset: 0,
        yOffset: this.getTopTogglesHeight() - (this.scrollBlurController?.getListStartOffset() as number)
      });
    });

    // 异步预构建编辑页布局
    this.loadEditTimerId = SysApiWrapper.setTimeout(() => {
      this.viewData.loadEditPage = true;
    }, DELAY_LOAD_EDIT_PAGE);

    // 提前执行编辑页显示动效，抵消编辑页显示动效准备时间
    this.showEditTimerId = SysApiWrapper.setTimeout(() => {
      TraceUtil.startTrace(DomainName.CC, 'showEdit');
      if (DropDownPanelManager.isPanelDismissing()) {
        log.showInfo('panel is dismissing, jumpToEditView canceled');
        this.hideEditPanelDirectly();
        TraceUtil.endTrace(DomainName.CC, 'jumpToEditView');
        return;
      }
      log.showInfo('jumpToEditView finished');
      this.viewData.showEditPage = true;
      sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.TOGGLE_EDIT));
      this.viewData.showEditModeHeader = true;
      this.viewData.showEditText = true;
      TraceUtil.endTrace(DomainName.CC, 'showEdit');
      TraceUtil.endTrace(DomainName.CC, 'jumpToEditView');
    }, DELAY_SHOW_EDIT_PAGE);
  }

  public afterQuitEdit = (): void => {
    TraceUtil.startTrace(DomainName.CC, 'afterQuitEdit');
    log.showInfo('afterQuitEdit');
    this.viewData.loadEditPage = false;
    this.viewData.showEditPage = false;
    QuickToggleController.getInstance().clearBackupToggleControllers();
    if (this.isIotEditSupported) {
      this.uiExtProxy?.send({ 'method': 'backToHome' });
    }
    this.viewData.showAddMoreButton = false;
    this.viewData.blankLayoutWeight = 1
    log.showInfo(`afterQuitEdit-viewData.blankLayoutWeight:${this.viewData.blankLayoutWeight}`);
    SysApiWrapper.animateTo({
      curve: Curve.Friction,
      duration: 300,
      onFinish: () => {
        log.showInfo(`afterQuitEdit-animateTo-onfinish-start`);
        if (this.isEditing) {
          log.showInfo('entering edit mode again');
        } else {
          this.viewData.blankLayoutWeight = 1;
        }
        TraceUtil.endTrace(DomainName.CC, 'afterQuitEdit');
        TraceUtil.endTrace(DomainName.CC, 'backHome');
      }
    }, () => {
      this.viewData.showEditModeHeader = false;
    });
    this.viewData.shouldClipHeadArea = true;
    SysApiWrapper.animateTo({
      curve: curves.interpolatingSpring(0, 1, 503, 45),
      onFinish: () => {
        if (!this.isEditing) {
          this.viewData.shouldClipHeadArea = false;
        }
      }
    }, () => {
      this.scroller.scrollTo({xOffset: 0, yOffset: -(this.scrollBlurController?.getListStartOffset() as number ?? 0)});
    });
    SysApiWrapper.animateTo({
      curve: Curve.Friction,
      duration: 350
    }, () => {
      this.viewData.mediaCardOpacity = 1;
      this.viewData.superTerminalOpacity = 1;
      this.viewData.focusOpacity = 1;
    });
    SysApiWrapper.animateTo({
      curve: Curve.Friction,
      duration: 300,
      tempo: undefined
    }, () => {
      this.viewData.showEditText = false;
    });
    SysApiWrapper.animateTo({
      curve: Curve.Friction,
      duration: 150
    }, () => {
      this.viewData.largeMediaCardOpacity = 1;
      this.viewData.largeMediaCardScale = 1;
    })
    this.isEditing = false;
    EvtBus.post(ControlCenterAnimatingEvent, { controlCenterAnimating: false });
  }

  public hideEditPanelDirectly = (): void => {
    log.showInfo('onPanelDismiss');
    this.clearTimer();
    this.viewData.loadEditPage = false;
    this.viewData.showAddMoreButton = false;
    this.viewData.blankLayoutWeight = 1;
    this.viewData.showEditPage = false;
    this.viewData.showEditModeHeader = false;
    this.viewData.showEditText = false;
    if (this.isIotEditSupported) {
      this.uiExtProxy?.send({ 'method': 'backToHome' });
    }
  }

  private clearTimer() {
    clearTimeout(this.loadEditTimerId);
    clearTimeout(this.showEditTimerId);
  }

  private getTopTogglesHeight(): number {
    return ROW_SPACE + (this.isLargeFoldStyle ? 64 : 144);
  }

  private getLargeFoldStyle(): boolean {
    let currentIndex: ControlCenterLayoutIndex = ControlCenterLayoutController.getInstance().getCurrentIndex();
    return currentIndex === ControlCenterLayoutIndex.FOLD_EXPANDED;
  }
}