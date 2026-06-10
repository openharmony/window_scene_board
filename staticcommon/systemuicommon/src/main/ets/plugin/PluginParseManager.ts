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

import {
  SingletonHelper,
  CommonUtils,
  ArrayUtils,
  LogDomain,
  LogHelper,
  TraceUtil,
  DomainName
} from '@ohos/basicutils';
import {
  AccountEvent,
  PluginStatusBarEvent,
  PluginToggleEvent,
  PluginConstants,
  PluginSlot,
  PluginClickType,
  PluginWindowType,
  PluginType,
  DeviceHelper,
  PluginComponentInfo,
  PluginLocalInfo,
  PluginClickInfo,
  PluginParseInfo,
  AccountMgr,
  EvtBus,
  PackageCommonEvent
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import type { PluginInfo } from '@ohos/frameworkwrapper';
import { PluginMessageInfo } from '@ohos/systemuiutils/src/main/ets/plugin/PluginMessageInfo';
import type { PluginEvent } from '@ohos/frameworkwrapper';
import worker from '@ohos.worker';
import type { MessageEvent } from '@ohos.worker';

const TAG = 'Plugin-PluginParseManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * promise回调类型
 */
type PluginResolve = (value: (Array<PluginInfo> | PromiseLike<Array<PluginInfo>>)) => void;

/**
 * plugin事件类型
 */
type PluginEventType<T extends PluginEvent> = new (...args: any[]) => T;

/**
 * 查询plugin时入参
 */
interface PluginParam {
  eventType: number; // 事件类型
  action: string; // 查询过滤action
  bundleName?: string; // 查询过滤应用
  userId?: number; // 用户id
}
/**
 * PluginComponent三方APP数据解析管理
 *
 * @since 2022-10-06
 */
class PluginParseManager {
  /**
   * 默认plugin action集
   */
  private static readonly DEFAULT_ACTIONS: string[] = [
    PluginConstants.ACTION_PLUGIN_STATUS_BAR,
    PluginConstants.ACTION_PLUGIN_TOGGLE,
  ];

  /**
   * action对应plugin事件类型
   */
  private static readonly ACTION_EVENT_TYPE: Map<string, PluginEventType<PluginEvent>> = new Map([
    [PluginConstants.ACTION_PLUGIN_STATUS_BAR, PluginStatusBarEvent],
    [PluginConstants.ACTION_PLUGIN_TOGGLE, PluginToggleEvent]
  ]);

  /**
   * 本应用plugin对应slot集，区分PC Phone
   * action => slot集
   */
  private static readonly LOCAL_PLUGIN_SLOT: Map<string, Array<string>> = new Map([
    // 状态栏本地slot
    [PluginConstants.ACTION_PLUGIN_STATUS_BAR, PluginSlot.getLocalSlot(PluginConstants.ACTION_PLUGIN_STATUS_BAR)],
    // 控制中心本地slot
    [PluginConstants.ACTION_PLUGIN_TOGGLE, PluginSlot.getLocalSlot(PluginConstants.ACTION_PLUGIN_TOGGLE)]
  ]);

  /**
   * 本应用plugin默认点击事件
   * plugin slot => 点击信息
   */
  private static readonly LOCAL_CLICK_INFO: Map<string, PluginClickInfo> = new Map([
  // 控制中心面板，弹窗
    [PluginSlot.SLOT_STATUS_CONTROL_CENTER, new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_LARGE)],
    // 通知中心面板，弹窗
    [PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL, new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_LARGE)],
    // 个人中心面板，弹窗
    [PluginSlot.SLOT_STATUS_PERSONAL, new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_SMALL)],
    // 电池面板，弹窗
    [PluginSlot.SLOT_STATUS_BATTERY_PANEL, new PluginClickInfo(PluginClickType.TYPE_WINDOW)],
    // 声音面板，弹窗
    [PluginSlot.SLOT_STATUS_SOUND_PANEL, new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_COMMON)],
    // 时钟日历面板，弹窗
    [PluginSlot.SLOT_STATUS_CLOCK_PANEL, new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_LARGE)],
    // 输入法:语言面板，弹窗
    [PluginSlot.SLOT_STATUS_INPUT_PANEL, new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_COMMON)],
    // 输入法面板，弹窗
    [PluginSlot.SLOT_STATUS_INPUT_METHOD, new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_COMMON)],
    // 企业空间面板，弹窗
    [PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE,
      new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_LARGE)],
    // 麦克风面板，弹窗
    [PluginSlot.SLOT_STATUS_MICROPHONE_PANEL, new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_COMMON)],
    // PC超级隐私面板，弹窗
    [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT, new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_COMMON)],
    // PADDLE超级隐私面板，弹窗
    [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE, new PluginClickInfo(PluginClickType.TYPE_WINDOW, PluginWindowType.TYPE_COMMON)],
    // 位置指示器面板，弹窗
    [PluginSlot.SLOT_STATUS_LOCATION, new PluginClickInfo(PluginClickType.TYPE_WINDOW)],
    // USB指示器面板，弹窗
    [PluginSlot.SLOT_STATUS_USB, new PluginClickInfo(PluginClickType.TYPE_WINDOW)],
  // TODO 控制中心本地开关点击事件
  ]);

  /**
   * 本应用plugin默认长按事件
   * plugin slot => 点击信息
   */
  private static readonly LOCAL_LONG_CLICK_INFO: Map<string, PluginClickInfo> = new Map([
  // TODO 控制中心 开关长按事件
  ]);

  /**
   * 本应用plugin默认是否显示红点
   * plugin slot => 点击信息
   */
  private static readonly LOCAL_RED_HOT: Map<string, boolean> = new Map([
  // PC通知面板显示红点
    [PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL, true]
  ]);

  /**
   * 异步线程worker
   */
  private mWorker?: worker.ThreadWorker;

  /**
   * 回调缓存
   * action+userId => PluginResolve集
   */
  private mCallbacks: Map<string, Set<PluginResolve>> = new Map();

  /**
   * plugin集
   * 多用户userID => plugin action => plugin集
   */
  private mUserPlugins: Map<number, Map<string, Array<PluginParseInfo>>> = new Map();

  /**
   * worker 事件通信id集
   * eventId => plugin查询参数
   */
  private mEventIds: Map<number, PluginParam> = new Map();

  /**
   * worker线程通信事件id
   */
  private mCurrentEventId: number = 0;

  /**
   * 当前用户id
   */
  private mCurrentUserId: number;

  private mUrl: string;

  /**
   * 初始化worker
   */
  initWorker(url: string): void {
    TraceUtil.startTrace(DomainName.SCB, 'PluginParseManager');
    // 已创建
    if (!CommonUtils.isInvalid(this.mWorker)) {
      log.showWarn('initWorker worker has created');
      TraceUtil.endTrace(DomainName.SCB, 'PluginParseManager');
      return;
    }
    if (CommonUtils.isEmpty(url)) {
      log.showWarn('initWorker url is null');
      TraceUtil.endTrace(DomainName.SCB, 'PluginParseManager');
      return;
    }
    log.showWarn('initWorker start: ' + url);
    this.mUrl = url;

    try {
      this.mWorker = new worker.ThreadWorker(url, { name: 'PluginWorker' });
    } catch (error) {
      log.error('initWorker error', error);
    }

    let isWorkerInvalid = CommonUtils.isInvalid(this.mWorker);
    // 监听worker线程回调
    if (!isWorkerInvalid) {
      this.mWorker.onmessage = this.onWorkerMessage.bind(this);
      this.mWorker.onmessageerror = this.onWorkerMessageErr.bind(this);
      this.mWorker.onexit = this.onWorkerClose.bind(this);
      // 同步初始化事件监听
      this.initAllEvent();
    }
    log.showInfo('initWorker init worker fail: ' + isWorkerInvalid);
    TraceUtil.endTrace(DomainName.SCB, 'PluginParseManager');
  }

  /**
   * 查询所有plugin数据
   *
   * @param action 过滤action
   * @param userId 可选，用户id
   * @return plugin数据集
   */
  async queryAllPluginInfo(action: string, userId?: number): Promise<Array<PluginInfo>> {
    return new Promise((resolve) => {
      if (!this.checkActionValid(action)) {
        resolve(null);
        log.showInfo('queryAllPluginInfo action invalid');
        return;
      }
      // 用户id
      this.getUserId(userId).then((id) => {
        let pluginInfos = this.mUserPlugins.get(id)?.get(action);
        // 已有缓存，直接返回，拷贝数组
        if (!ArrayUtils.isEmpty(pluginInfos)) {
          resolve(this.castPluginInfo(pluginInfos));
          return;
        }
        // 无缓存，等待回调
        this.putCallbackResolve(action, id, resolve);
      });
    });
  }

  /**
   * 通过slot查找pluginInfo
   *
   * @param action plugin action
   * @param slot plugin唯一标示
   */
  getPluginParseInfo(action: string, slot: string): PluginParseInfo {
    if (CommonUtils.isInvalid(this.mCurrentUserId)) {
      return null;
    }
    return this.mUserPlugins.get(this.mCurrentUserId)?.get(action)?.find((info) => {
      return info.pluginSlot === slot;
    });
  }

  /**
   * 获取所有本地图标
   * @param action 业务类型（状态栏或控制中心）
   * @returns 本地图标
   */
  getLocalPluginInfo(action: string): PluginInfo[] {
    const pluginInfos = PluginParseManager.LOCAL_PLUGIN_SLOT
      .get(action)
      .map((slot) => this.createLocalPlugin(action, slot));

    return this.castPluginInfo(pluginInfos);
  }

  /**
   * 初始化包管理、用户切换事件监听
   */
  private initAllEvent(): void {
    // 监听安装包变化，即时刷新plugin配置信息
    EvtBus.on(PackageCommonEvent, this.handlePackageEvent.bind(this));
    // 监听用户切换，重新查询所有plugin
    EvtBus.on(AccountEvent, this.handleAccountEvent.bind(this));
    // 生产plugin配置解析事件
    EvtBus.produceOn(PluginStatusBarEvent, this.handleProducePluginStatusBarEvent.bind(this));
    EvtBus.produceOn(PluginToggleEvent, this.handleProducePluginToggleEvent.bind(this));
  }

  /**
   * 刷新查询所有plugin
   */
  private refreshAllPlugin(): void {
    this.getActions().forEach((action) => {
      this.queryPluginInfo({ eventType: PluginConstants.EVENT_TYPE_QUERY_ALL, action: action });
    });
  }

  /**
   * 处理状态栏plugin事件生产
   *
   * return plugin事件
   */
  private handleProducePluginStatusBarEvent(): PluginStatusBarEvent {
    return this.tryCreatePluginEvent(PluginConstants.ACTION_PLUGIN_STATUS_BAR);
  }

  /**
   * 处理控制中心plugin事件生产
   *
   * return plugin事件
   */
  private handleProducePluginToggleEvent(): PluginToggleEvent {
    return this.tryCreatePluginEvent(PluginConstants.ACTION_PLUGIN_TOGGLE);
  }

  /**
   * 生产plugin事件
   *
   * @param action plugin action
   */
  private tryCreatePluginEvent<T extends PluginEvent>(action: string): T {
    let pluginInfos = this.mUserPlugins?.get(this.mCurrentUserId)?.get(action);
    if (ArrayUtils.isEmpty(pluginInfos)) {
      return null;
    }
    return this.createPluginEvent<T>(PluginConstants.EVENT_TYPE_QUERY_ALL, action, pluginInfos);
  }

  /**
   * 处理用户切换事件回调
   *
   * @param event 用户切换事件
   */
  private handleAccountEvent(event: AccountEvent): void {
    let currentId = event?.accountInfo?.localId;
    log.showInfo('handleAccountEvent new id: ' + currentId);
    if (CommonUtils.isInvalid(currentId)) {
      log.showInfo('handleAccountEvent change id invalid');
      return;
    }
    this.mCurrentUserId = currentId;
    // 取出非当前userID的数据缓存
    this.mUserPlugins.forEach((value, userId) => {
      // 允许保留主用户数据
      if (userId !== currentId && !AccountMgr.isAdminAccount(userId)) {
        this.mUserPlugins.delete(userId);
      }
    });
    // 重新查询所有plugin刷新
    this.refreshAllPlugin();
  }

  /**
   * 处理包管理事件回调
   *
   * @param event 包管理事件
   */
  private handlePackageEvent(event: PackageCommonEvent): void {
    if (CommonUtils.isInvalid(event?.event)) {
      log.showInfo('handlePackageEvent package event unknown');
      return;
    }
    log.showInfo('handlePackageEvent event: ' + event.event);
    switch (event.event) {
      case PackageCommonEvent.EVENT_PACKAGE_REMOVED:
      case PackageCommonEvent.EVENT_PACKAGE_FULL_REMOVED:
        // 包卸载,移除对应plugin
        this.resolveRemovePackage(event);
        break;
      case PackageCommonEvent.EVENT_PACKAGE_ADD:
        // 包新安装
        this.resolveAddUpdatePackage(event, PluginConstants.EVENT_TYPE_ADD_PLUGIN);
        break;
      case PackageCommonEvent.EVENT_PACKAGE_REPLACED:
      case PackageCommonEvent.EVENT_PACKAGE_CHANGED:
        // 包更新
        this.resolveAddUpdatePackage(event, PluginConstants.EVENT_TYPE_UPDATE_PLUGIN);
        break;
      default:
        log.showInfo('handlePackageEvent package event invalid');
        break;
    }
  }

  /**
   * 处理包安装更新广播事件
   *
   * @param event 包事件
   * @param eventType 事件类型
   */
  private resolveAddUpdatePackage(event: PackageCommonEvent, eventType: number): void {
    this.getActions().forEach((action) => {
      this.queryPluginInfo({
        eventType: eventType,
        action: action,
        bundleName: event.bundleName,
        userId: event.userId
      });
    });
  }

  /**
   * 处理卸载包广播事件
   *
   * @param event 包卸载事件
   */
  private resolveRemovePackage(event: PackageCommonEvent): void {
    let userAction = this.mUserPlugins.get(event.userId);
    if (ArrayUtils.isEmpty(userAction)) {
      log.showInfo('resolveRemovePackage has not plugin at this user: ' + event.userId);
      return;
    }
    // 所有action检查删除
    this.getActions().forEach((action) => {
      let deletePlugins = this.deletePluginByBundleName(userAction.get(action), event.bundleName);
      this.checkLocalPlugin(event.userId, action, deletePlugins);
    });
  }

  /**
   * 删除远程plugin后，检测是否本地plugin补充
   *
   * @param userId 用户id
   * @param action plugin action
   * @param deleteInfos 已删除plugin集
   */
  private checkLocalPlugin(userId: number, action: string, deleteInfos: Array<PluginParseInfo>): void {
    if (ArrayUtils.isEmpty(deleteInfos)) {
      return;
    }
    // 三方应用删除后，如果有本地plugin，则继续使用本地plugin
    let updatePlugins: Array<PluginParseInfo> = new Array();
    let realDelPlugins: Array<PluginParseInfo> = new Array();
    let localSlots = PluginParseManager.LOCAL_PLUGIN_SLOT.get(action);
    deleteInfos.forEach((info) => {
      let slot = info.pluginSlot;
      if (ArrayUtils.contains(localSlots, slot)) {
        updatePlugins.push(this.createLocalPlugin(action, slot));
      } else {
        realDelPlugins.push(info);
      }
    });
    // 更新本地plugin
    if (!ArrayUtils.isEmpty(updatePlugins)) {
      this.postPluginEvent(PluginConstants.EVENT_TYPE_UPDATE_PLUGIN, userId, action, updatePlugins);
    }
    // 真实删除的plugin
    if (!ArrayUtils.isEmpty(realDelPlugins)) {
      this.postPluginEvent(PluginConstants.EVENT_TYPE_DELETE_PLUGIN, userId, action, realDelPlugins);
    }
  }

  /**
   * 删除指定包名plugin
   *
   * @param plugins plugin集
   * @param bundleName 指定包名
   */
  private deletePluginByBundleName(plugins: Array<PluginParseInfo>, bundleName: string): Array<PluginParseInfo> {
    if (ArrayUtils.isEmpty(plugins)) {
      return null;
    }
    let result: Array<PluginParseInfo> = new Array();
    let length = plugins.length;
    for (let i = length - 1; i >= 0; i--) {
      let plugin = plugins[i];
      if (plugin.bundleName === bundleName) {
        plugins.splice(i, 1);
        result.push(plugin);
      }
    }
    return result;
  }

  /**
   * 异步查询plugin数据
   *
   * @param params 入参
   */
  private queryPluginInfo(params: PluginParam): void {
    if (CommonUtils.isInvalid(params)) {
      log.showInfo('queryPluginInfo worker has not ready or param err');
      return;
    }
    if (CommonUtils.isInvalid(this.mWorker)) {
      if (!this.initWorkThread()) {
        return;
      }
    }
    this.getUserId(params.userId).then((id) => {
      // 记录用户id
      params.userId = id;
      let msgInfo: PluginMessageInfo = new PluginMessageInfo();
      msgInfo.action = params.action;
      // 过滤metadata名称与action保持一致
      msgInfo.metadataName = params.action;
      msgInfo.userId = id;
      // 指定应用
      if (params?.bundleName) {
        msgInfo.bundleName = params?.bundleName;
      }
      // 缓存回调器
      let eventId = this.generateEventId();
      this.mEventIds.set(eventId, params);
      log.showInfo(`mEventIds size start ${this.mEventIds.size} eventId ${eventId}`);
      // 开启plugin查询
      msgInfo.eventId = eventId;
      this.mWorker?.postMessage(msgInfo);
    });
  }

  /**
   * worker线程数据正常回调
   *
   * @param event 回调事件
   */
  private onWorkerMessage(event: MessageEvent<PluginMessageInfo>): void {
    // 无数据
    if (CommonUtils.isInvalid(event?.data)) {
      log.showDebug('onWorkerMessage no event data');
      return;
    }
    let msg = event?.data;
    log.showInfo(`onWorkerMessage parse success: ${msg.eventId}, action: ${msg.action}, code: ${msg.errCode}`);
    // 处理资源json请求
    if (msg.errCode === PluginMessageInfo.ERR_CODE_REQUEST_JSON) {
      this.requestGetPluginJson(msg);
      return;
    }
    // 处理plugin结果
    this.postPluginResult(msg.eventId, msg.pluginInfos);
  }

  /**
   * worker线程数据异常回调
   *
   * @param event 回调事件
   */
  private onWorkerMessageErr(event: MessageEvent<PluginMessageInfo>): void {
    let msg = event?.data;
    log.showInfo(`onWorkerMessageErr rec msg fail: ${msg?.eventId}`);
    if (!CommonUtils.isInvalid(msg)) {
      this.postPluginResult(msg.eventId, msg.pluginInfos);
    }
  }

  /**
   * 请求plugin资源json串
   *
   * @param msg 通信信息
   */
  private requestGetPluginJson(msg: PluginMessageInfo): void {
    log.showInfo(`requestGetPluginJson resName:${msg.resName} bundleName:${msg.bundleName}`);
    ResUtils.getOutStringByName(msg.resName, msg.bundleName).then((resJson) => {
      msg.resJson = resJson;
      msg.errCode = PluginMessageInfo.ERR_CODE_RESPONSE_JSON;
      this.mWorker?.postMessage(msg);
    });
  }

  /**
   * 回调plugin加载结果
   *
   * @param eventId 事件id
   * @param pluginInfos plugin结果
   */
  private postPluginResult(eventId: number, pluginInfos: Array<PluginParseInfo>): void {
    let param = this.mEventIds.get(eventId);
    if (CommonUtils.isInvalid(param)) {
      log.showInfo('postPluginResult eventId has not param: ' + eventId);
      return;
    }
    let castInfos = this.castThreadParseInfo(pluginInfos);
    // 清除事件
    this.mEventIds.delete(eventId);
    switch (param.eventType) {
      case PluginConstants.EVENT_TYPE_ADD_PLUGIN:
      case PluginConstants.EVENT_TYPE_UPDATE_PLUGIN:
        // 区分新增/更新plugin，EventBus通知
        this.resolveAddUpdatePlugin(param, castInfos);
        break;
      case PluginConstants.EVENT_TYPE_QUERY_ALL:
        // 查询action对应所有plugin
        this.resolveQueryAllPlugin(param, castInfos);
        break;
      default:
        log.showInfo('postPluginResult has not event type');
        break;
    }

    log.showInfo(`mEventIds size end ${this.mEventIds?.size}`);
    if (this.mEventIds?.size === 0) {
      this.mWorker?.terminate();
      log.showInfo('Terminate work thread');
    }
  }

  /**
   * 线程间数据传递，类型会被擦除，重新创建对象
   *
   * @param oriInfos 子线程来源数据
   * @return 转换后数据
   */
  private castThreadParseInfo(oriInfos: Array<PluginParseInfo>): Array<PluginParseInfo> {
    if (ArrayUtils.isEmpty(oriInfos)) {
      return null;
    }
    let result: Array<PluginParseInfo> = new Array();
    oriInfos.forEach((info) => {
      let newInfo = new PluginParseInfo();
      newInfo.copy(info);
      result.push(newInfo);
    });
    return result;
  }

  /**
   * 处理区分plugin的新增、更新
   *
   * @param param plugin查询入参
   * @param pluginInfos plugin查询结果
   */
  private resolveAddUpdatePlugin(param: PluginParam, pluginInfos: Array<PluginParseInfo>): void {
    if (ArrayUtils.isEmpty(pluginInfos)) {
      return;
    }
    let pluginArr = this.mUserPlugins.get(param.userId)?.get(param.action);
    // 区分新增、更新
    let addPlugins: Array<PluginParseInfo> = new Array();
    let updatePlugins: Array<PluginParseInfo> = new Array();
    pluginInfos.forEach((info) => {
      let oriIndex = ArrayUtils.findIndex(pluginArr, info);
      // 新增
      if (oriIndex === -1) {
        addPlugins.push(info);
        this.putPluginInfo(param.action, param.userId, info);
        return;
      }
      // 更新
      let oriInfo = pluginArr[oriIndex];
      if (oriInfo.checkUpdate(info)) {
        updatePlugins.push(info);
        ArrayUtils.updateByIndex(pluginArr, oriIndex, info);
      }
    });
    // 发送新增、更新事件
    this.postPluginEvent(PluginConstants.EVENT_TYPE_ADD_PLUGIN, param.userId, param.action, addPlugins);
    this.postPluginEvent(PluginConstants.EVENT_TYPE_UPDATE_PLUGIN, param.userId, param.action, updatePlugins);
  }

  /**
   * 处理查询所有plugin事件
   *
   * @param param plugin查询入参
   * @param pluginInfos plugin查询结果
   */
  private resolveQueryAllPlugin(param: PluginParam, pluginInfos: Array<PluginParseInfo>): void {
    let allInfos = this.addLocalPlugin(param.action, pluginInfos);
    if (ArrayUtils.isEmpty(allInfos)) {
      log.showInfo('resolveQueryAllPlugin has not plugin: ' + param.action + ', id: ' + param.userId);
      return;
    }
    // 缓存plugin集，init
    this.setPluginInfos(param.action, param.userId, allInfos);
    // 回调主动查询监听器
    let key = this.userActionKey(param.action, param.userId);
    let resultInfos = this.castPluginInfo(allInfos);
    this.mCallbacks.get(key)?.forEach((resolve) => resolve(resultInfos));
    this.mCallbacks.delete(key);
    // 发送查询所有plugin事件
    this.postPluginEvent(PluginConstants.EVENT_TYPE_QUERY_ALL, param.userId, param.action, allInfos);
  }

  /**
   * 发送plugin新增、更新、查询所有事件
   *
   * @param eventType 事件类型
   * @param userId 用户id
   * @param action plugin action
   * @param pluginInfos plugin集
   */
  private postPluginEvent(eventType: number, userId: number, action: string, pluginInfos: Array<PluginParseInfo>): void {
    if (ArrayUtils.isEmpty(pluginInfos)) {
      log.showInfo('postPluginEvent has not plugin: ' + eventType + ', action: ' + action);
      return;
    }
    // 用户匹配当前用户
    AccountMgr.getCurrentAccountId().then((id) => {
      if (userId !== id) {
        log.showInfo('postPluginEvent user id not match, tarId: ' + userId + ', currentId: ' +
        id + ', eventType: ' + eventType);
        return;
      }
      let eventClass = PluginParseManager.ACTION_EVENT_TYPE.get(action);
      let event = this.createPluginEvent(eventType, action, pluginInfos);
      EvtBus.post(eventClass, event);
      log.showInfo('postPluginEvent send plugin event: ' + pluginInfos.length + ', type: ' + eventType +
      ', action: ' + action);
    });
  }

  /**
   * worker线程退出回调
   *
   * @param code 错误码
   */
  private onWorkerClose(code: number): void {
    log.showInfo('onWorkerClose code: ' + code);
    this.mWorker = undefined;
    this.mCallbacks.clear();
    this.mCurrentEventId = 0;
  }

  /**
   * 创建plugin事件
   *
   * @param eventType 事件类型
   * @param action plugin action
   * @param pluginInfos plugin配置数据集
   */
  private createPluginEvent<T extends PluginEvent>(eventType: number, action: string, pluginInfos: Array<PluginParseInfo>): T {
    if (ArrayUtils.isEmpty(pluginInfos)) {
      return null;
    }
    let eventClass = PluginParseManager.ACTION_EVENT_TYPE.get(action);
    if (CommonUtils.isInvalid(eventClass)) {
      return null;
    }
    let pluginEvent = new eventClass();
    pluginEvent.action = action;
    pluginEvent.eventType = eventType;
    pluginEvent.pluginInfos = this.castPluginInfo(pluginInfos);
    return pluginEvent as T;
  }

  /**
   * plugin配置信息转换组件信息
   *
   * @param pluginInfos 配置信息集
   * @return 组件信息集
   */
  public castPluginInfo(pluginInfos: Array<PluginParseInfo>): Array<PluginInfo> {
    let result: Array<PluginInfo> = new Array();
    pluginInfos?.forEach((info) => {
      if (CommonUtils.isInvalid(info)) {
        return;
      }
      let isLocalPlugin = info.isLocalPlugin;
      let pluginInfo = isLocalPlugin ? new PluginLocalInfo() : new PluginComponentInfo();
      pluginInfo.pluginParseInfo = info;
      if (pluginInfo instanceof PluginComponentInfo) {
        pluginInfo.pluginData = {};
        pluginInfo.templateSource = info.pluginTemplateName;
        pluginInfo.templateAbility = info.pluginAbilityName;
      }
      if (info.pluginSlot === PluginSlot.SLOT_STATUS_MICROPHONE_PANEL) {
        pluginInfo.pluginParseInfo.pluginType = PluginType.PLUGIN_TYPE_MESSAGE;
      }
      if (info.pluginSlot === PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT ||
        info.pluginSlot === PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE) {
        pluginInfo.pluginParseInfo.pluginType = PluginType.PLUGIN_TYPE_MESSAGE;
      }
      result.push(pluginInfo);
    });
    return result;
  }

  /**
   * 添加本地应用plugin集
   *
   * @param action plugin action
   * @return plugin本地集
   */
  private addLocalPlugin(action: string, remoteInfos: Array<PluginParseInfo>): Array<PluginParseInfo> {
    let slots = PluginParseManager.LOCAL_PLUGIN_SLOT.get(action);
    let result: Array<PluginParseInfo> = new Array();
    slots?.forEach((slot) => {
      // 远程图标优先级更高
      if (this.remoteHasSlot(slot, remoteInfos)) {
        return;
      }
      result.push(this.createLocalPlugin(action, slot));
    });
    if (!ArrayUtils.isEmpty(remoteInfos)) {
      result = result.concat(remoteInfos);
    }
    return result;
  }

  /**
   * 创建本地plugin图标
   *
   * @param action plugin action
   * @param slot 图标标示
   */
  public createLocalPlugin(action: string, slot: string): PluginParseInfo {
    let pluginInfo = new PluginParseInfo();
    pluginInfo.bundleName = 'com.ohos.sceneboard';
    pluginInfo.action = action;
    pluginInfo.pluginSlot = slot;
    pluginInfo.clickInfo = PluginParseManager.LOCAL_CLICK_INFO.get(slot);
    pluginInfo.longClickInfo = PluginParseManager.LOCAL_LONG_CLICK_INFO.get(slot);
    pluginInfo.isNeedRedHot = PluginParseManager.LOCAL_RED_HOT.get(slot) ?? false;
    pluginInfo.checkParams();
    return pluginInfo;
  }

  /**
   * 检测图标是否已存在，远程图标优先级更高
   *
   * @param slot 图标标示
   * @param remoteInfos 远程图标集
   */
  private remoteHasSlot(slot: string, remoteInfos: Array<PluginParseInfo>): boolean {
    if (ArrayUtils.isEmpty(remoteInfos)) {
      return false;
    }
    let result = remoteInfos.find((info) => {
      return info?.pluginSlot === slot;
    });
    return !CommonUtils.isInvalid(result);
  }

  /**
   * 获取有效用户id
   */
  private async getUserId(userId?: number): Promise<number> {
    if (!CommonUtils.isInvalid(userId)) {
      return userId;
    }
    return AccountMgr.getCurrentAccountId();
  }

  /**
   * 缓存plugin
   *
   * @param action plugin action
   * @param userId 用户id
   * @param pluginInfo plugin信息
   */
  private putPluginInfo(action: string, userId: number, pluginInfo: PluginParseInfo): void {
    let userMap = this.mUserPlugins.get(userId);
    if (CommonUtils.isInvalid(userMap)) {
      userMap = new Map();
      this.mUserPlugins.set(userId, userMap);
    }
    let actionArr = userMap.get(action);
    if (CommonUtils.isInvalid(actionArr)) {
      actionArr = new Array();
      userMap.set(action, actionArr);
    }
    actionArr.push(pluginInfo);
  }

  /**
   * 缓存plugin集
   *
   * @param action plugin action
   * @param userId 用户id
   * @param pluginInfos plugin集
   */
  private setPluginInfos(action: string, userId: number, pluginInfos: Array<PluginParseInfo>): void {
    if (!this.mUserPlugins.has(userId)) {
      let userAction: Map<string, Array<PluginParseInfo>> = new Map();
      userAction.set(action, pluginInfos);
      this.mUserPlugins.set(userId, userAction);
    } else {
      this.mUserPlugins.get(userId).set(action, pluginInfos);
    }
  }

  /**
   * 缓存回调器
   *
   * @param action plugin action
   * @param userId 用户id
   * @param resolve 回调器
   */
  private putCallbackResolve(action: string, userId: number, resolve: PluginResolve): void {
    let key = this.userActionKey(action, userId);
    let resolveSet = this.mCallbacks.get(key);
    if (CommonUtils.isInvalid(resolveSet)) {
      resolveSet = new Set();
      this.mCallbacks.set(key, resolveSet);
    }
    resolveSet.add(resolve);
  }

  /**
   * 检测action有效性
   *
   * @param action plugin action
   */
  private checkActionValid(action: string): boolean {
    return PluginParseManager.DEFAULT_ACTIONS.indexOf(action) >= 0;
  }

  /**
   * 生成键值
   *
   * @param action plugin action
   * @param userId 用户id
   */
  private userActionKey(action: string, userId: number): string {
    return action + userId;
  }

  /**
   * 生成事件id
   *
   * @return 事件id
   */
  private generateEventId(): number {
    let eventId = this.mCurrentEventId;
    while (this.mEventIds.has(eventId)) {
      eventId++;
    }
    this.mCurrentEventId = eventId;
    return eventId;
  }

  private initWorkThread(): boolean {
    try {
      this.mWorker = new worker.ThreadWorker(this.mUrl, { name: 'PluginWorker' });
    } catch (error) {
      log.error('initWorkThread error', error);
    }

    let isWorkerInvalid = CommonUtils.isInvalid(this.mWorker);
    // 监听worker线程回调
    if (!isWorkerInvalid) {
      this.mWorker.onmessage = this.onWorkerMessage.bind(this);
      this.mWorker.onmessageerror = this.onWorkerMessageErr.bind(this);
      this.mWorker.onexit = this.onWorkerClose.bind(this);
      log.showInfo('init worker thread successful');
      return true;
    }
    log.showInfo('init worker thread false');
    return false;
  }

  private getActions(): string[] {
    let actions = [...PluginParseManager.DEFAULT_ACTIONS];
    // 手机状态栏不接入remote plugin
    if (DeviceHelper.isPhone()) {
      actions = actions.filter((action) => action !== PluginConstants.ACTION_PLUGIN_STATUS_BAR);
    }

    return actions;
  }
}

// 单例
export let PluginParseMgr = SingletonHelper.getInstance(PluginParseManager, TAG);