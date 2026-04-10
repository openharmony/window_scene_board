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
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  SCBFoldStatePropertyChangeEvent, SCBPropertyChangeReason, SCBScreenProperty,
  SCBScreenSessionManager } from '@ohos/windowscene';
import { EventManager, EvtBus, HiSysEventUtil, ViewCallback, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import Constants from '../common/Constants';
import { KeyCode } from '@kit.InputKit';
import { styleMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { display, uiAppearance, window } from '@kit.ArkUI';

const TAG: string = 'ForceExtensionComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct ForceExtensionComponent {
  persistentId: number = 0;
  @State message: string = '加速SA界面';
  @State viewController: BaseViewController = new BaseViewController(ViewType.FORCE_EXIT_COMPONENT);
  @StorageLink('isForceExtensionComponentShow') @Watch('updateForceExtensionComponentShow') isForceExtensionComponentShow: boolean = false;
  private myProxy: UIExtensionProxy | undefined = undefined;
  context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private closeMsg: boolean = false;
  @Link screenProp: SCBScreenProperty;
  @State private windowWidth: number = 0;
  @State private windowHeight: number = 0;
  @State private foldedStatus: boolean = false;

  private mViewCallback: ViewCallback = {
    onShow: (): void => undefined
  };

  private updateForceExtensionComponentShow(): void {
    this.isForceExtensionComponentShow = AppStorage.get<boolean>('isForceExtensionComponentShow') as boolean;
    log.showInfo(`updateForceExtensionComponentShow isForceExtensionComponentShow: ${this.isForceExtensionComponentShow}`);
    this.updateForceExtensionComponentRect();
    if (this.isForceExtensionComponentShow) {
      this.viewController.show();
    } else {
      this.viewController.hide();
    }
  }

  private updateForceExtensionComponentRect(): void {
    this.viewController?.updateArea({
      left: 0,
      top: 0,
      width: px2vp(this.screenProp.width),
      height: px2vp(this.screenProp.height)
    });
    this.viewController?.updateRect({
      left: 0,
      top: 0,
      width: px2vp(this.screenProp.width),
      height: px2vp(this.screenProp.height)
    });
  }

  screenPropertyChangeForceExitCallbacks = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.screenProp = screenProperty;
    this.windowWidth = px2vp(screenProperty.width);
    this.windowHeight = px2vp(screenProperty.height);
    this.updateForceExtensionComponentRect();
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear Start');
    viewMgrPolicy.registerViewController(ViewType.FORCE_EXIT_COMPONENT, this.viewController);
    this.viewController.registerCallback(this.mViewCallback);
    this.viewController.updateId(this.persistentId);
    this.windowWidth = px2vp(this.screenProp.width);
    this.windowHeight = px2vp(this.screenProp.height);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.screenPropertyChangeForceExitCallbacks, this.screenProp.screenId);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear Start');
    viewMgrPolicy.unregisterViewController(ViewType.FORCE_EXIT_COMPONENT);
    this.viewController.unRegisterCallback(this.mViewCallback);
    this.eventMgr.offAll();
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeForceExitCallbacks, this.screenProp.screenId);
  }

  @Builder
  forceExitUIAbility() {
    Column() {
      UIExtensionComponent({
        bundleName: 'com.ohos.taskmanager',
        abilityName: 'ForceCloseAppAbility',
        moduleName: 'manager',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI',
        }
      })
        .onRemoteReady((proxy) => {
          this.myProxy = proxy;
        })
        .onResult((data) => {
          this.message = JSON.stringify(data);
        })
        .onRelease((code) => {
          this.message = 'release code: ' + code;
        })
        .onError((error: BusinessError) => {
          log.showError(`onError: ${error.message}`);
        })
        .onReceive((data) => {
          this.message = JSON.stringify(data);
          if (this.message === '{"action":"Close"}') {
            AppStorage.setOrCreate('isForceExtensionComponentShow', false);
          }
        })
        .size({ width: this.windowWidth, height: this.windowHeight })
        .position({ x: 0, y: 0 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onKeyEvent((event: KeyEvent) => {
      if (event.keyCode === KeyCode.KEYCODE_ESCAPE && event.type === KeyType.Up) {
        HiSysEventUtil.reportKey('usual.event.ESC');
        AppStorage.setOrCreate('isForceExtensionComponentShow', false);
      }
    })
  }

  build() {
    if (this.isForceExtensionComponentShow) {
      this.forceExitUIAbility();
    }
  }
}