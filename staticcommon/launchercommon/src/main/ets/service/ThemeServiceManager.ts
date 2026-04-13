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

import { rpc } from '@kit.IPCKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import common from '@ohos.app.ability.common';
import ThemeServiceConnector from './ThemeServiceConnector';

const TAG = 'ThemeServiceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SCB_ONLINE_THEME_SCENE = 2;

/**
 * 和ThemeOpenServiceExtAbility交互的具体实现。
 * 通过本类直接调用ThemeOpenServiceExtAbility接口，不用关注调用接口的具体实现，简洁明了。
 */
export class ThemeServiceManager {
  private serviceProxy?: rpc.IRemoteObject;
  private context: common.UIAbilityContext;
  private readonly COMMAND_CHECK_SCB_ONLINE_THEME = 6;
  private readonly COMMAND_CHECK_RESOURCE_RESULT = 13;
  private readonly CLEAR_SCENE = '3';
  private readonly CHECK_SCENE = '0';

  public constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  private async connect(): Promise<void> {
    log.showInfo('connect');
    try {
      this.serviceProxy = await ThemeServiceConnector.connect(this.context);
      log.showInfo('success connect');
    } catch (err) {
      log.showError(`error connect service: err = ${err}`);
    }
  }

  private disConnect(): void {
    log.showInfo('disConnect');
    ThemeServiceConnector.disconnect(this.context);
  }

  public async checkScbOnlineTheme(): Promise<void> {
    log.showInfo('checkScbOnlineTheme');
    await this.connect();
    let option = new rpc.MessageOption();
    let dataSequence = rpc.MessageSequence.create();
    let replaySequence = rpc.MessageSequence.create();
    try {
      dataSequence.writeInt(SCB_ONLINE_THEME_SCENE);
    } catch (e) {
      log.showError('checkScbOnlineTheme write scene failed, message: ' + e?.message);
    }
    this.serviceProxy?.sendMessageRequest(this.COMMAND_CHECK_SCB_ONLINE_THEME,
      dataSequence, replaySequence, option)
      .then((result: rpc.RequestResult) => {
        log.showInfo(`checkScbOnlineTheme sendMessageRequest success result code = ${result?.code}`);
      })
      .catch((e: Error) => {
        log.showError('checkScbOnlineTheme sendMessageRequest failed, message: ' + e?.message);
      })
      .finally(() => {
        dataSequence.reclaim();
        replaySequence.reclaim();
        this.disConnect();
      });
  }

  public async checkResourseResult(contentId: string): Promise<string> {
    await this.connect();
    let option = new rpc.MessageOption();
    let dataSequence = rpc.MessageSequence.create();
    let replaySequence = rpc.MessageSequence.create();

    dataSequence.writeString('');
    dataSequence.writeString(contentId);
    dataSequence.writeString(this.CHECK_SCENE);
    const promise: Promise<string> = new Promise((resolve, reject) => {
      this.serviceProxy?.sendMessageRequest(this.COMMAND_CHECK_RESOURCE_RESULT,
        dataSequence, replaySequence, option)
        .then((result: rpc.RequestResult) => {
          this.getResult(result, resolve, reject);
        })
        .catch((e: Error) => {
          log.showError(`checkResourseResult sendMessageRequest failed, message: ${e?.message}`);
          reject();
        })
        .finally(() => {
          dataSequence.reclaim();
          replaySequence.reclaim();
          this.disConnect();
        });
    });
    return promise;
  }

  public getResult(result: rpc.RequestResult, resolve: (value: string) => void, reject: () => void): void {
    if (result.errCode === 0) {
      let errCodeVar: number = result.reply.readInt();
      if (errCodeVar !== 0) {
        let returnValueVar = result.reply.readString();
        log.showInfo(`checkResourseResult sendMessageRequest success1, returnValue = ${returnValueVar}`);
        resolve(returnValueVar);
      }
      let returnValueVar = result.reply.readString();
      log.showInfo(`checkResourseResult sendMessageRequest success2, returnValue = ${returnValueVar}`);
      resolve(returnValueVar);
    } else {
      log.showInfo(`checkResourseResult sendMessageRequest failed, errCode = ${result?.errCode}`);
      reject();
    }
  }
}
