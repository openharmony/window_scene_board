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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { sEventManager } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import { obtainLocalEvent } from '@ohos/frameworkwrapper/src/main/ets/utils/EventUtil';
import { TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import { ControlCenterState } from '@ohos/controlcentercommon/src/main/ets/common/ControlCenterConstants';
import AVSessionManager from '@ohos.multimedia.avsession';
import audio from '@ohos.multimedia.audio';
import power from '@ohos.power';
import Constants, { CurOutputDevTS } from '../Util/Constants';
import sControlCenterScreenLockController from '@ohos/controlcentercommon/src/main/ets/base/CommonScreenLockController';

const TAG = 'CardMediaControllerDc';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export class CardMediaControllerDc {
  private static controller: CardMediaControllerDc | undefined = undefined;

  public static getInstance(): CardMediaControllerDc {
    if (!CardMediaControllerDc.controller) {
      CardMediaControllerDc.controller = new CardMediaControllerDc();
    }
    return CardMediaControllerDc.controller;
  }

  /**
   * 下拉事件广播
   * @param targetPanel
   */
  panelStateChange(targetPanel: TargetPanel) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'panelStateChange', targetPanel});
  }

  /**
   * 消息订阅
   */
  doSubscribeNotify() {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'doSubscribeNotify'});
  }

  /**
   * 播控卡片显示数据刷新
   * @param formId
   * @param skipInit
   */
  startShowing(formId: string, skipInit: boolean = false, forceUpdate?: boolean) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'startShowing', formId, skipInit, forceUpdate,
    });
  }

  /**
   * 上一首
   */
  callShowingPrevious() {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'previous'});
  }

  /**
   * 下一首
   */
  callShowingNext() {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'next'});
  }

  /**
   * 快进快退
   * @param command
   * @param parameter
   */
  callRewindOrForward(command: AVSessionManager.AVControlCommandType, parameter: number) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: command, skipIntervals: parameter,
    });
  }

  /**
   * 冷启动
   */
  startShowingDefaultApp() {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'startShowingDefaultApp'});
  }

  /**
   * 暂停
   */
  callShowingPause() {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'pause'});
  }

  /**
   * 播放
   * @param isColdStart
   */
  callShowingPlay(isColdStart: boolean = false) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'play', isColdStart});
  }

  /**
   * 指定应用播放
   * @param sessionId
   * @param isColdStart
   * @param isForceTopSession
   */
  callPlay(sessionId: string, isColdStart: boolean, isForceTopSession: boolean = false) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER,
      {type: 'callPlay', sessionId, isColdStart, isForceTopSession});
  }

  /**
   * 进度跳转
   * @param time
   */
  callSeek(time: number) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'seek', time});
  }

  /**
   * 循环模式
   * @param time
   */
  callLoopMode(loopMode: number) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'loopMode', loopMode});
  }

  /**
   * 启动历史歌单
   */
  startHistoryApp() {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'startHistoryApp'});
  }

  /**
   * 收藏
   * @param assetId
   * @param isFavor
   */
  callFavorites(assetId: string | number, isFavor: boolean) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'favor', assetId, isFavor});
  }

  /**
   * 锁屏跳转
   * @param sessionId
   */
  jumpAppWithScreenLock(sessionId?: string) {
    sControlCenterScreenLockController.handleOnControlCenterWithScreenLock(() => {
      messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'jumpAppWithScreenLock', sessionId});
    }, false);
  }

  /**
   * 跳转应用
   * @param sessionId
   */
  startAimApp(sessionId: string) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'startAimApp', sessionId});
  }

  /**
   * 跳转到播控
   * @param isSwitch
   * @param curOutputDev
   * @param iconInfo
   * @param isLocal
   */
  jumpInside(isSwitch: boolean, curOutputDev: CurOutputDevTS, iconInfo: audio.DeviceType | undefined,
    isLocal: boolean = true) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'jumpInside',
      isSwitch: isSwitch,
      curDeviceType: curOutputDev.deviceType,
      curDeviceId: curOutputDev.deviceId,
      curDeviceAddress: curOutputDev.deviceAddress,
      curDeviceNetworkId: curOutputDev.networkId,
      iconInfo: iconInfo,
      isLocal: isLocal,
    });
  }

  /**
   * 关闭播控
   */
  jumpOutside() {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'jumpOutside'});
  }

  /**
   * 上报折叠屏设备日志
   * @param sessionId
   * @param startTime
   */
  reportExpandShowDeviceList(sessionId: string, startTime: number) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'reportExpandShowDeviceList', sessionId, startTime,
    });
  }

  /**
   * 刷新数据
   */
  doSessionCollection() {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'doSessionCollection'});
  }

  /**
   * 移除通知卡片
   * @param notifyId
   * @param from
   */
  postNotificationCancelEvent(notifyId: string, from?: string) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'postNotificationCancelEvent', notifyId, from,
    });
  }

  /**
   * 设备变更触发的通知
   * @param isNotificationFromDeviceChange
   */
  setNotificationFromDeviceChange(isNotificationFromDeviceChange: boolean) {
    AppStorage.setOrCreate('isNotificationFromDeviceChange', isNotificationFromDeviceChange);
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'setNotificationFromDeviceChange', isNotificationFromDeviceChange,
    });
  }

  /**
   * 设置通知卡片是否显示
   * @param isMediaNtfShowing
   */
  setNtfShowing(isMediaNtfShowing: boolean) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'setNtfShowing', isMediaNtfShowing,
    });
  }

  /**
   * 移除已存在的通知
   * @param notifyId
   * @param forceRemove
   */
  removeExistedNotification(notifyId: string, forceRemove: boolean = false) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'removeExistedNotification', notifyId, forceRemove,
    });
  }

  /**
   * 判断当前是否亮屏
   * @returns
   */
  isPowerActive(): boolean {
    try {
      return power.isActive();
    } catch (err) {
      log.showError(`check active status failed`);
    }
    return false;
  }

  /**
   * 关闭二级页
   */
  closeSubWindow() {
    GlobalContext.getInstance().setObject('isMediaCenterShow', false);
    sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MAIN_LAYOUT));
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, { type: 'closeSubWindow' });
  }

  /**
   * 播放歌单
   *
   * @param bundleName 包名
   * @param avQueueId 歌单id
   */
  playAvQueue(bundleName: string, avQueueId: string) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER,
      { type: 'playAvQueue', bundleName: bundleName, avQueueId: avQueueId });
  }

  getHistoricalAndRecommendData() {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, { type: 'getHistoricalAndRecommendData' });
  }

  isJumpFromList(sessionId: string): Object {
    return messageChannel.callObject(Constants.ASYNC_CARD_MEDIA_CONTROLLER, 'isJumpFromList', sessionId);
  }
}