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

import { LogDomain, LogHelper, Observer, } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import { EventManager, EvtBus, ViewType, WindowEvent, viewMgrPolicy, PluginSlot,
  ScreenOnOffEvent,
  ViewArea,
  sEventManager,
  HideWindowPanelEvent} from '@ohos/frameworkwrapper';
import MediaPlaybackComponent from '@ohos/mediacontrolcomponent/src/main/ets/default/pages/MediaPlaybackComponent';
import { WindowConstants } from '@ohos/commonconstants';
import { WindowAnimMgr, windowMgr } from '@ohos/windowscene';
import { MultimodalInputManager, MultiKeyCode, AbilityComponentMgr, } from '@ohos/systemuicommon';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';

const TAG = 'Ctrl.MediaCardLayoutPcMode';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
/**
 * 窗口名称
 */
const WINDOW_NAME = PluginSlot.SLOT_CONTROL_MEDIA_PLAY_PANEL;

@Component
export default struct SCBMediaPlayPanel {
  @State mediaPlayPanelCtrl: PcStbSecondaryPanelController =
    new PcStbSecondaryPanelController(ViewType.MEDIA_PLAY_PANEL);
  @State showMedia: boolean = false;
  @Provide persistentId: number = 0;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private screenLockObserver: Observer | null = null;
  private hideWindowPanelEvent = (event: HideWindowPanelEvent): void => {
    this.hideWindow();
  }

  /**
   * 窗口show/hide事件回调
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    if (event.isWindowStartShow()) {
      if (event.isMatchName(WindowConstants.WINDOW_NAME_BANNER)) {
        return;
      }
      if (!event.isMatchName(WINDOW_NAME)) {
        this.hideWindow();
      }
    }
  }

  private hideWindow(): void {
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      return;
    }
    log.showInfo(TAG, `hide anim start`);
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
  }

  private initWindowPolicy() {
    log.showInfo(TAG, `init Battery panel window Policy`);
    // 窗口show/hide事件
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      this.onWindowEvent(event)
    })
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent) => {
        this.onScreenOnOffEvent(event)
      })
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent(event: ScreenOnOffEvent): void {
    // 熄屏隐藏面板
    if (event.isScreenOff()) {
      // 提前隐藏弹框
      windowMgr.hideWindowImmediately(WINDOW_NAME);
    }
  }

  aboutToAppear() {
    viewMgrPolicy.registerViewController(ViewType.MEDIA_PLAY_PANEL, this.mediaPlayPanelCtrl);
    this.mediaPlayPanelCtrl.updateId(this.persistentId);
    let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    let rect: ViewArea = {
      left: controlCenterPosition.left,
      top: controlCenterPosition.top,
      width: 312,
      height: 398,
    };
    this.mediaPlayPanelCtrl.updateArea(rect);
    this.mediaPlayPanelCtrl.updateRect(rect);
    this.initWindowPolicy();
    // 窗口动画绑定onFrame
    windowMgr.startBindWinAnimOnFrame(WINDOW_NAME);
    this.eventMgr.on(HideWindowPanelEvent, this.hideWindowPanelEvent)
    this.mediaPlayPanelCtrl.registerFocusCallback();
    // 锁屏监听
    this.screenLockObserver = {
      notify: (): void => {
        log.showInfo(TAG, 'onLockScreen');
        this.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);
  }

  onLockScreen(): void {
    this.hideWindow();
  }

  aboutToDisappear() {
    log.showInfo(TAG, `aboutToDisappear`);
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
    if (this.screenLockObserver) {
      screenLockMediator.deleteObserver(this.screenLockObserver);
    }
  }

  build() {
    MediaPlaybackComponent().id('mediaPlaybackComponent')
      .gesture(PanGesture({ direction: PanDirection.Horizontal }))
  }
}

