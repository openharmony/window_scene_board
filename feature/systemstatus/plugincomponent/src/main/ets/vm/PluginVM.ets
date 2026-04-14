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

import {
  PluginComponentMgr,
  PluginPushListener
} from '@ohos/systemuicommon';
import {
  CommonUtils,
  ArrayUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  EvtBus,
  SCBWindowSceneConfig,
  PluginComponentInfo,
  PluginInfo,
  PluginParseInfo,
  WindowPositionChangeEvent
} from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { SCBConstants } from '@ohos/commonconstants';
import { LottieViewModel } from '@ohos/systemuicommon';
// instrument ignore file
const TAG = 'PluginVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 远程plugin push事件监听器
 */
export type OnRemotePluginPushListener = (info: PluginComponentInfo) => void;

/**
 * Plugin图标业务处理
 *
 * @since 2022-11-22
 */
export class PluginVM implements PluginPushListener<PluginComponentInfo> {
  /**
   * plugin数据
   */
  private pluginInfo: PluginInfo | null = null;

  /**
   * 远程plugin push事件监听器集
   */
  private pushListeners: Set<OnRemotePluginPushListener> = new Set();

  /**
   * lottie图标动画状态
   */
  private lottieAnimating: Map<string, boolean> = new Map();

  /**
   * plugin解析信息
   *
   * PluginPushListener实现
   */
  public parseInfo: PluginParseInfo = new PluginParseInfo();

  /**
   * plugin对象创建器
   *
   * PluginPushListener实现
   */
  public pluginClassCreater = () => { return new PluginComponentInfo() };

  /**
   * plugin远程push事件
   * PluginPushListener实现
   *
   * @param info 远程数据
   */
  onPush(info: PluginComponentInfo): void {
    if (CommonUtils.isInvalid(info)) {
      return;
    }
    let slot = this.pluginInfo?.pluginParseInfo?.pluginSlot ?? '';
    // 胶囊模式只响应当前用户消息请求
    let currentUserId: number | undefined = AppStorage.get<number>('mCurrentUserId');
    if (DeviceHelper.isPC() && CommonUtils.isNumber(info.requestUserId) && CommonUtils.isNumber(currentUserId) &&
      info.requestUserId != currentUserId) {
      log.showWarn(`onPush slot: ${slot} info.requestUserId: ${info.requestUserId} != currentUserId: ${currentUserId}`);
      return;
    }
    let hasClickWindow = info.hasClickWindow();
    log.showInfo(`onPush slot: ${slot}, windth: ${info.requestWidth}, requestCloseWindow: ${info.requestCloseWindow}, \
    requestOpenWindow: ${info.requestOpenWindow}, hasClickWindow: ${hasClickWindow}, \
    window is show :${windowMgr.isShowing(slot)}`);
    info.pluginParseInfo.pluginSlot = slot;
    if (!hasClickWindow) {
      this.dispatchPushEvent(info);
      return;
    }
    // 请求关闭弹窗，有弹窗则关闭
    if (info.requestCloseWindow) {
      windowMgr.updateDestroyWindowFlag(slot, info.requestDestroyWindow);
      windowMgr.hideWindowWithAnim(slot);
    }
    // 请求打开弹窗，无弹窗则打开
    if (info.requestOpenWindow) {
      if (this.isPcType()) {
        let position = windowMgr.getWindowPosition(slot);
        EvtBus.post(WindowPositionChangeEvent, { windowName: slot,
          position: this.pluginInfo?.pluginParseInfo.pluginPosition, area: position });
      }
      windowMgr.updateDestroyWindowFlag(slot, false);
      windowMgr.showWindowWithAnim(slot);
    }
    // 更新弹窗高度
    if (info.requestWindowHeight != 0) {
      log.showInfo(`slot: ${slot}, height: ${info.requestWindowHeight}`);
      let position = windowMgr.getWindowPosition(slot);
      position.height = vp2px(info.requestWindowHeight);
      if (this.isPcType()) {
        EvtBus.post(WindowPositionChangeEvent, { windowName: slot,
          position: this.pluginInfo?.pluginParseInfo.pluginPosition, area: position });
      } else {
        windowMgr.updateWindowPosition(slot, position);
      }
    }
    // 其他场景UI处理
    this.dispatchPushEvent(info);
  }

  private isPcType(): boolean {
    const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    return uiType === SCBConstants.UITYPE_PC || DeviceHelper.is2In1DevicePcType();
  }

  /**
   * 初始化
   *
   * @param info数据
   */
  init(info: PluginInfo): void {
    this.pluginInfo = info;
    // 远程plugin场景
    if (!info?.pluginParseInfo?.isLocalPlugin) {
      this.pushListeners = new Set();
      this.parseInfo = info.pluginParseInfo;
      PluginComponentMgr.registerPushListener(this);
    }
    // TODO local场景
  }

  /**
   * 回收
   */
  onDestroy(): void {
    // 注销push监听
    PluginComponentMgr.unregisterPushListener(this);
    // 清空数据
    this.pushListeners?.clear();
    this.lottieAnimating.clear();
    this.pluginInfo = null;
  }

  /**
   * 注册push监听
   *
   * @param listener 监听器
   */
  registerOnRemotePushListener(listener: OnRemotePluginPushListener): () => void {
    if (CommonUtils.isInvalid(listener)) {
      return () => {};
    }
    this.pushListeners?.add(listener);
    return () => this.unregisterOnRemotePushListener(listener);
  }

  /**
   * 注销push监听
   *
   * @param listener 监听器
   */
  unregisterOnRemotePushListener(listener: OnRemotePluginPushListener): void {
    this.pushListeners?.delete(listener);
  }

  /**
   * 分发push事件
   *
   * @param info 远程数据
   */
  private dispatchPushEvent(info: PluginComponentInfo): void {
    if (ArrayUtils.isEmpty(this.pushListeners)) {
      return;
    }
    this.pushListeners.forEach((listener) => {
      listener(info);
    });
  }

  /**
   * 获取plugin图标是否处于Lottie动效状态
   *
   * @param slot plugin唯一标识
   */
  getLottieAnimatingState(slot: string) {
    if (!LottieViewModel.isLottieComponent(slot)) {
      return false;
    }
    return this.lottieAnimating?.get(slot);
  }

  /**
   * 设置plugin图标Lottie动效状态
   *
   * @param slot plugin唯一标识
   * @param status true:图标处于lottie动画中
   */
  setLottieAnimatingState(slot: string, status: boolean) {
    if (!LottieViewModel.isLottieComponent(slot)) {
      return;
    }
    this.lottieAnimating?.set(slot, status);
  }
}