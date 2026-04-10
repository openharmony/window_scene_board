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

import { curves } from '@kit.ArkUI';
import { CommonUtils, LogHelper, LogDomain } from '@ohos/basicutils';
import {
  viewMgrPolicy,
  ViewType,
  ViewArea,
  EvtBus,
  EventManager,
  PluginSlot } from '@ohos/frameworkwrapper';
import {
  ResUtils,
  SCBScreenProperty,
  windowMgr,
  SCBFoldStatePropertyChangeEvent,
  SCBScreenSessionManager,
  SCBPropertyChangeReason,
  SCBSceneSessionManager
} from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { RTLUtil } from '@ohos/componenthelper';
import { BaseViewController } from '@ohos/frameworkcommon';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import { NtfHeadsUpVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfHeadsUpVM';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { NotificationClose } from '@ohos/notificationcomponent/src/main/ets/pages/common/NotificationClose';
import { NtfCloseVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfCloseVM';
import { notificationStyle } from '@ohos/notificationcomponent/src/main/ets/vm/style/NotificationStyle';
import { NtfColorModeVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfColorModeVM';
import { NotificationHeadsUpPc } from '@ohos/notificationcomponent/src/main/ets/pages/phone/NotificationHeadsUpPc';
import { NotificationListStylePc } from './style/NotificationListStylePc';
import { NotificationItemStylePc } from './style/NotificationItemStylePc';
import { LayoutViewModel } from '@ohos/launchercommon';
import { PcSmartDockStyleManager } from '@ohos/pcsmartdock/src/main/ets/default/common/PcSmartDockStyleManager';

notificationStyle.setListStyle(new NotificationListStylePc());
notificationStyle.setItemStyle(new NotificationItemStylePc());

const TAG = 'NotificationPanel-BannerNotification';
const COMPONENT_ID_BANNER_CONTENT = TAG + '_Content';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 横幅最大高度
 */
const MAX_HEADS_UP_HEIGHT = 600;

/**
 * 窗口名
 */
const WINDOW_NAME = WindowConstants.WINDOW_NAME_BANNER;
const BANNER_MARGIN_TOP = 40;
const SHADOW_MARGIN = 100;
const BANNER_WIDTH = 328;
const TRANSITION_DURATION = 250;
const CONTENT_MARGIN_RIGHT = 16;

@Component
export struct SCBBannerNotification {
  persistentId: number = 0;
  /**
   * 横幅通知VM
   */

  private headsUpVM: NtfHeadsUpVM = new NtfHeadsUpVM();
  @Link screenProp: SCBScreenProperty;
  @State viewController: BaseViewController = new BaseViewController(ViewType.NOTIFICATION_BANNER);
  /**
   * 通知数据
   */
  @State ntfEntries: NotificationEntry[] = [];
  /**
   * 通知列表类型
   */
  @Provide notificationType: number = NotificationType.TYPE_PC;
  /**
   * 面板触摸事件down点，仅用于适配NotificationSingleItem
   */
  @Provide panelDownGlobalY: number = -1;
  // 面板触摸down点，全局X轴点，-1无触摸
  @Provide panelDownGlobalX: number = -1;
  /**
   * 窗口是否可见，仅用于适配NotificationSingleItem
   */
  @Provide isNtfWindowShow: boolean = false;
  @Provide isItemExpanded: boolean = false;
  @State NtfItemScale: number = 1;
  @State isInitParam: boolean = false;
  /**
   * 横幅通知显示区域
   */
  @State rect: ViewArea = {
    left: 0,
    top: 0,
    width: 0,
    height: 0
  };
  @Provide colorModeVM: NtfColorModeVM = new NtfColorModeVM();
  /**
   * 记录左滑状态的通知的哈希值，用于左滑状态互斥（同一时刻，只允许一条通知左滑）
   */
  @Provide swipeHashCode: string = '';
  /**
   * close按钮VM
   */
  @Provide private closeVM: NtfCloseVM = new NtfCloseVM();
  /**
   * 记录展示按钮的通知的哈希值，用于互斥操作
   */
  @Provide displayButtonsHashCode: string = '';
  /**
   * 记录是否window模式，被控制中心面板挡住
   */
  @State isBlocked: boolean = false;
  /**
   * 锁屏是否加锁状态
   */
  @Provide isKeyguardLock: boolean = false;
  responseRegionMap: Map<string, Rectangle> = new Map();
  rtlChangeCallback: Function = () => {
    this.updateBannerWindowPosition();
  }
  /**
   * 统一事件管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  adaptiveScreenWidth: number = 0;
  adaptiveScreenHeight: number = 0;

  /**
   * 获取通知数据
   * HeadsUpCallback
   *
   * @return 通知数据
   */
  getNtfEntries(): NotificationEntry[] {
    return this.ntfEntries;
  }

  /**
   * 通知数据变更
   * HeadsUpCallback
   *
   * @param ntfEntries 通知数据
   */
  notifyNtfEntryChange(ntfEntries: NotificationEntry[], isAddEntry: boolean): void {
    log.showInfo(`notifyNtfEntryChange: ${ntfEntries.length}`);
    if (isAddEntry) {
      this.isBlocked = windowMgr.isShowing(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      this.updateBannerWindowPosition();
    }
    for (const key of this.responseRegionMap.keys()) {
      if (!ntfEntries.some(item => item.hashCode === key)) {
        this.responseRegionMap.delete(key);
        this.viewController.setResponseRegion(Array.from(this.responseRegionMap.values()));
      }
    }
    // 融合模式常驻通知排在下面
    ntfEntries.sort((a, b) => (a.isHeadsUpStick ? 1 : -1) - (b.isHeadsUpStick ? 1 : -1));
    animateTo({
      duration: TRANSITION_DURATION,
      curve: Curve.Friction
    }, () => {
      this.ntfEntries = ntfEntries;
      this.ntfEntries.forEach((item: NotificationEntry) => {
        item.notifyDataChanged();
      });
    })
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear Start');
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.setSkipSelfWhenShowOnVirtualScreen(true);
    }
    viewMgrPolicy.registerViewController(ViewType.NOTIFICATION_BANNER, this.viewController);
    this.viewController.updateId(this.persistentId);
    // 更新窗口圆角
    windowMgr.updateWindowRadius(WINDOW_NAME, WindowConstants.getDefaultRadius());
    this.adaptiveScreenHeight = this.screenProp.height;
    this.adaptiveScreenWidth = this.screenProp.width;
    this.updateBannerWindowPosition();
    // 初始化
    this.headsUpVM.init(this);
    this.colorModeVM.init();
    RTLUtil.registerRtlChangeCallback(this.rtlChangeCallback);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallBack,
      this.screenProp?.screenId);
  }

  updateBannerWindowPosition() {
    // 计算横幅显示区域
    const width = vp2px(BANNER_WIDTH + SHADOW_MARGIN);
    const height = MAX_HEADS_UP_HEIGHT;
    // 右对齐
    this.rect = {
      left: this.getLeft(width),
      top: this.getTop(height),
      width: width,
      height: height
    };
    log.showInfo(`updateBannerWindowPosition: ${JSON.stringify(this.rect)}`);
    windowMgr.updateWindowPosition(WINDOW_NAME, this.rect);
  }

  getLeft(width: number) {
    const left = this.adaptiveScreenWidth - width;
    return RTLUtil.isRTL() ? 0 : left;
  }

  getTop(height: number): number {
    const dockHeight = PcSmartDockStyleManager.getStyle(this.screenProp).mDockHeight;
    log.showInfo(`dockHeight: ${dockHeight} vp`);
    const macStyleTop = vp2px(BANNER_MARGIN_TOP);
    const windowStyleBlockedTop = vp2px(2);
    const windowStyleTop = this.adaptiveScreenHeight - vp2px(dockHeight) - height;
    return this.isBlocked ? windowStyleBlockedTop : windowStyleTop;
  }

  screenPropertyChangeCallBack = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`screenPropertyChangeCallBack reason: ${reason}`);
    if (reason && reason === SCBPropertyChangeReason.CHANGE_MODE ||
      reason === SCBPropertyChangeReason.SCREEN_CONNECT) {
      this.adaptiveScreenHeight = this.screenProp.height;
      this.adaptiveScreenWidth = this.screenProp.width;
      this.updateBannerWindowPosition();
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisAppear');
    this.eventMgr.offAll();
    this.headsUpVM.onDestroy();
    this.colorModeVM.deinit();
    RTLUtil.unregisterRtlChangeCallback(this.rtlChangeCallback);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallBack,
      this.screenProp?.screenId);
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.setSkipSelfWhenShowOnVirtualScreen(false);
    }
  }

  build() {
    Column() {
      Column() {
        ForEach(this.ntfEntries, (item: NotificationEntry) => {
          NotificationHeadsUpPc({
            ntfEntry: item,
            isHeadsUp: true,
            isGestureDisable: false,
            headsUpVM: this.headsUpVM,
            radius: ResUtils.getConvertNumber($r('app.float.ntf_item_corner_radius')),
            itemScaleX: this.NtfItemScale,
            itemScaleY: this.NtfItemScale,
            isInitParam: this.isInitParam,
            isBlocked: this.isBlocked,
            innerMargin: SHADOW_MARGIN - CONTENT_MARGIN_RIGHT * 2,
            shadowStyle: {
              radius: $r('app.float.ntf_pc_banner_shadow_radius'),
              color: $r('app.color.ntf_pc_banner_shadow_color'),
            },
            onContentAreaChange: (newArea, entry) => {
              if (newArea.height === 0) {
                return;
              }
              let winPos = windowMgr.getWindowPosition(WINDOW_NAME);
              let region: Rectangle = {
                x: vp2px(newArea?.globalPosition?.x as number) - winPos.left,
                y: vp2px(newArea?.globalPosition?.y as number) - winPos.top,
                width: vp2px(newArea?.width as number),
                height: vp2px(newArea?.height as number)
              };
              this.responseRegionMap.set(entry.hashCode, region);
              this.viewController.setResponseRegion(Array.from(this.responseRegionMap.values()));
            }
          })
        }, (item: NotificationEntry) => item.hashCode)
        NotificationClose({
          headsUpVM: this.headsUpVM,
        })
      }
      .id(COMPONENT_ID_BANNER_CONTENT)
      .width(BANNER_WIDTH)
      .height('100%')
      .justifyContent(this.isBlocked ? FlexAlign.Start : FlexAlign.End)
      .margin({
        right: CONTENT_MARGIN_RIGHT,
        left: CONTENT_MARGIN_RIGHT
      })
      .onAreaChange((_oldArea, newArea) => {
        this.closeVM?.setContainerPosition(newArea.globalPosition);
      })
    }
    .alignItems(HorizontalAlign.End)
    .borderRadius($r('app.float.ntf_item_corner_radius'))
    .width('100%')
    .height('100%')
  }
}
