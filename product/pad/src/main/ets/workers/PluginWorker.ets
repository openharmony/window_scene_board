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

import worker, { ThreadWorkerGlobalScope, MessageEvent } from '@ohos.worker';
import { LogDomain, LogHelper, ArrayUtils, CommonUtils } from '@ohos/basicutils';
import { PluginMessageInfo } from '@ohos/systemuicommon';
import { ParseConfigUtils } from '@ohos/systemuicommon';

const TAG = 'Plugin-PluginWorker';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 等待请求json类型
 */
type RequestResolve = (pluginJson: string | PromiseLike<string>) => void;

/**
 * plugin管理，worker线程
 *
 * @since 2022-10-06
 */
class PluginWorker {
    /**
     * worker线程消息接收器
     */
  private port: ThreadWorkerGlobalScope = worker.workerPort;

    /**
     * json请求等待集
     */
  private pluginJsonResolve: Map<number, RequestResolve> = new Map();

    /**
     * 构造
     */
  constructor() {
    if (this.port) {
      this.port.onmessage = this.onMainMessage;
      this.port.onmessageerror = this.onMainMessageErr;
    }
    log.showInfo('constructor init worker fail: ' + !this.port);
  }

    /**
     * 请求plugin json串
     *
     * @param msg 通信
     * @param resName 资源名
     * @param bundleName 包名
     */
  private async requestPluginJson(msg: PluginMessageInfo, resName: string, bundleName: string): Promise<string> {
    return new Promise((resolve) => {
      this.pluginJsonResolve.set(msg.eventId, resolve);
      msg.bundleName = bundleName;
      msg.resName = resName;
      msg.errCode = PluginMessageInfo.ERR_CODE_REQUEST_JSON;
      try {
        this.port?.postMessage(msg);
      } catch (error) {
        log.error('requestPluginJson postMessage error', error);
      }

    });
  }

    /**
     * 主线程数据正常回调
     *
     * @param event 回调事件
     */
  private onMainMessage = (event: MessageEvent<PluginMessageInfo>): void => {
    if (CommonUtils.isInvalid(event?.data)) {
      log.showDebug('onMainMessage no event data');
      return;
    }
    let messageInfo = event.data;
    log.showDebug('onMainMessage eventId:%{public}d,action:%{public}s', messageInfo.eventId, messageInfo.action);
        // json请求响应
    if (messageInfo.errCode === PluginMessageInfo.ERR_CODE_RESPONSE_JSON) {
      let resolve = this.pluginJsonResolve.get(messageInfo.eventId);
      if (resolve) {
        resolve(messageInfo.resJson ?? '');
      }
      this.pluginJsonResolve.delete(messageInfo.eventId);
      return;
    }
        // 无action、metadata过滤，无法加载
    if (CommonUtils.isEmpty(messageInfo.action) || CommonUtils.isEmpty(messageInfo.metadataName)) {
      messageInfo.errCode = PluginMessageInfo.ERR_CODE_PARAM_INVALID;
      messageInfo.errMessage = 'param err, no action or metadata.';
      try {
        this.port?.postMessage(messageInfo);
      } catch (error) {
        log.error('onMainMessage postMessage error', error);
      }
      return;
    }
        // 加载plugin数据
    ParseConfigUtils.parsePluginInfo(messageInfo.action, messageInfo.userId, messageInfo.metadataName,
      messageInfo.bundleName, {
        requestPluginJson: (resName: string, bundleName: string): Promise<string> => {
          return this.requestPluginJson(messageInfo, resName, bundleName);
        }
    }).then((pluginInfos) => {
      if (ArrayUtils.isEmpty(pluginInfos)) {
        messageInfo.errCode = PluginMessageInfo.ERR_CODE_NO_DATA;
        messageInfo.errMessage = 'parse action: ' + messageInfo.action + ' no data.';
        try {
          this.port?.postMessage(messageInfo);
        } catch (error) {
          log.error('parsePluginInfo postMessage error', error);
        }
        return;
      }
          // 加载成功
      messageInfo.errCode = PluginMessageInfo.ERR_CODE_SUCCESS;
      messageInfo.pluginInfos = pluginInfos;
      try {
        this.port?.postMessage(messageInfo);
      } catch (error) {
        log.error('parsePluginInfo postMessage error', error);
      }
    });
  }

    /**
     * 主线程数据异常回调
     *
     * @param event回调事件
     */
  private onMainMessageErr = (event: MessageEvent<PluginMessageInfo>): void => {
    log.showError('onMainMessageErr rec msg fail，eventId：%{public}d,action:%{public}s ',
      event?.data?.eventId, event?.data?.action);
  }
}

// 触发worker线程
new PluginWorker();
