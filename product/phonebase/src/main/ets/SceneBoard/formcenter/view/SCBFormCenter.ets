/**
	* Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/utils/CheckEmptyUtils';
import {
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBEventId,
} from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  ViewType,
  viewMgrPolicy,
  DeviceHelper,
  ViewCallback,
  ViewArea,
  GlobalContext,
} from '@ohos/frameworkwrapper';
import { ScreenLockFormAni } from '@ohos/screenlockwidget/src/main/ets/formAni/ScreenLockFormAni';
import { ScreenLockAniScene } from '@ohos/screenlockwidget/src/main/ets/formAni/ScreenLockFormAniMgr';
import { FormCenterView } from '@ohos/form/src/main/ets/formcenter/view/FormCenterView';
import {
  FormCompanionComponent,
  FormCreateAnimationComponent
} from '@ohos/form/src/main/ets/default/view/FormCompanionComponent';
import { FormAnimateComponent } from '@ohos/form/src/main/ets/default/view/FormAnimateComponent';
import { FormEditView } from '@ohos/form/src/main/ets/default/view/FormEditView';
import { FormEditSecPageView } from '@ohos/form/src/main/ets/default/view/FormEditSecPageView';
import { FormManagerView } from '@ohos/form/src/main/ets/formcenter/view/FormManagerView';
import { CommonConstants, FormCenterViewManager, FormCenterLocation } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG: string = 'SCBFormCenter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SEARCH, TAG);
const DELAY_SKIP_DRAW: number = 50;
const RESET_SHEET_DELAY: number = 500;

@Component
export struct SCBFormCenter {
  private persistentId: number = 0;
  private childSet: Set<string> = new Set();
  private timeoutId: number = CommonConstants.INVALID_VALUE;
  private hotAreaMap: Map<string, number> = new Map();
  private childViewCallback: ViewCallback = {
    onShow: (component: string) => {
      const formCenterLocation: FormCenterLocation = FormCenterViewManager.getInstance().getFormCenterLocation();
      log.showInfo(`${component} onShow on ${formCenterLocation}`);
      this.childSet.add(component);
      this.mViewController.setTouchable(true);
      // 锁屏页面的卡片中心不聚焦
      if (formCenterLocation !== FormCenterLocation.SCREEN_LOCK) {
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setFocusable(true);
        SCBSceneSessionManager.getInstance().requestFocus(this.persistentId, false);
      }
      if (this.timeoutId >= 0) {
        clearTimeout(this.timeoutId);
        this.timeoutId = CommonConstants.INVALID_VALUE;
      }
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setSkipDraw(false);
      this.mViewController.setResponseRegion([{
        x: this.screenProp.left,
        y: this.screenProp.top,
        width: this.screenProp.width,
        height: this.screenProp.height
      }]);
    },
    onHide: (component: string) => {
      log.showInfo(`${component} onHide ${this.childSet.size}`);
      this.childSet.delete(component);
      this.hotAreaMap.delete(component);
      if (this.childSet.size === 0) {
        this.setUnfocus();
        this.mViewController.setTouchable(false);
        this.timeoutId = setTimeout(() => {
          this.timeoutId = CommonConstants.INVALID_VALUE;
          if (this.childSet.size === 0) {
            SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setSkipDraw(true);
          }
        }, DELAY_SKIP_DRAW);
      }
      const formCenterLocation: FormCenterLocation = FormCenterViewManager.getInstance().getFormCenterLocation();
      if (this.childSet.size === 1 && formCenterLocation === FormCenterLocation.SCREEN_LOCK) {
        this.updateWindowHotArea();
      } else {
        this.resetWindowHotArea();
      }
    },
    onHeightChange: (component: string, height: number) => {
      log.showInfo(`current onHeightChange component:${component}, height:${height}`);
      // 此处高度单位为px,与窗口单位一致,可直接使用
      if (this.childSet.size === 0) {
        return;
      }
      if (this.childSet.size === 2 || CheckEmptyUtils.isEmpty(height)) {
        log.showInfo('current formmanage show, reset hotArea');
        this.resetWindowHotArea();
        return;
      }
      this.hotAreaMap.set(component, height);
      this.updateWindowHotArea();
    }
  };
  private screenPropertyChangeCallbackFunc = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`screen width: ${screenProperty.width}, screen height: ${screenProperty.height}`);
    let newRect: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(screenProperty.width),
      height: px2vp(screenProperty.height)
    };

    this.mViewController.updateRect(newRect);

    // 更新响应热区
    this.mViewController.setResponseRegion([{
      x: this.screenProp.left,
      y: this.screenProp.top,
      width: this.screenProp.width,
      height: this.screenProp.height,
    }]);
  };
  @Link screenProp: SCBScreenProperty;
  @State mViewController: BaseViewController = new BaseViewController(ViewType.FORM_CENTER);

  private setUnfocus(): void {
    log.showInfo('set SCBFormCenter Unfocus');
    SCBSceneSessionManager.getInstance().requestUnfocus(this.persistentId);
    SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setFocusable(false);

    this.mViewController.setResponseRegion([{
      x: this.screenProp.left,
      y: this.screenProp.top,
      width: 0,
      height: 0
    }]);
  }

  private resetWindowHotArea(): void {
    this.mViewController.setResponseRegion([{
      x: this.screenProp.left,
      y: this.screenProp.top,
      width: this.screenProp.width,
      height: this.screenProp.height
    }]);
  }

  private updateWindowHotArea(): void {
    let height: number = Math.max(...Array.from(this.hotAreaMap.values()));
    this.mViewController.setResponseRegion([{
      x: this.screenProp.left,
      y: this.screenProp.height - height,
      width: this.screenProp.width,
      height: height
    }]);
  }

  private backGestureHandler(): void {
    log.showInfo('SCBFormCenter backGestureHandler');
    GlobalContext.getContext().eventHub.emit(CommonConstants.CANCEL_ADD_FORM_ANIMATION);
    FormCenterViewManager.getInstance().formCenterBackGestureHandler();
  }

  private homeGestureHandler(): void {
    log.showInfo('SCBFormCenter homeGestureHandler');
    GlobalContext.getContext().eventHub.emit(CommonConstants.CANCEL_ADD_FORM_ANIMATION);
    FormCenterViewManager.getInstance().formCenterHomeGestureHandler();
    this.resetSheet();
  }

  private resetSheet(): void {
    let timerId: number = setTimeout(() => {
      log.showInfo(`reset sheet ${this.childSet.size}`);
      clearTimeout(timerId);
      timerId = CommonConstants.INVALID_VALUE;
      this.childSet.clear();
      this.setUnfocus();
      this.mViewController.setTouchable(false);
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setSkipDraw(true);
    }, RESET_SHEET_DELAY);
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear ${this.persistentId}`);
    this.mViewController.updateId(this.persistentId);
    this.mViewController.show();
    SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setFocusable(false);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      this.screenPropertyChangeCallbackFunc, undefined, false, this.persistentId);
    this.mViewController.setTouchable(false);
    SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setSkipDraw(true);
    viewMgrPolicy.registerViewController(ViewType.FORM_CENTER, this.mViewController);
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId,
      () => this.backGestureHandler());
    viewMgrPolicy.onGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId,
      () => this.homeGestureHandler());
    GlobalContext.getContext().eventHub.on(CommonConstants.UNFOCUS_SCB_FORM_CENTER, () => this.setUnfocus());
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(
      this.screenPropertyChangeCallbackFunc, undefined, false, this.persistentId);
    viewMgrPolicy.unregisterViewController(ViewType.FORM_CENTER);
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.offGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId);
    GlobalContext.getContext().eventHub.off(CommonConstants.UNFOCUS_SCB_FORM_CENTER);
  }

  build() {
    Stack() {
      FormCenterView({ mViewStateChangeCallback: this.childViewCallback })
      FormManagerView({ mViewStateChangeCallback: this.childViewCallback })
      FormEditView({ mViewStateChangeCallback: this.childViewCallback })
      FormEditSecPageView()
      FormCreateAnimationComponent({ mViewStateChangeCallback: this.childViewCallback })
      FormCompanionComponent()
      FormAnimateComponent({ mViewStateChangeCallback: this.childViewCallback })
      ScreenLockFormAni({
        scene: ScreenLockAniScene.BIND_SHEET
      })
    }
    .id(`${TAG}_Stack`)
    .height('100%')
    .width('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .backgroundColor(Color.Transparent)
  }
}
