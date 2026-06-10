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

import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import Want from '@ohos.app.ability.Want';
import { rpc } from '@kit.IPCKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Caller } from '@ohos.app.ability.UIAbility';
import { threadCall, ThreadCallType } from '@ohos/systemuicommon/src/main/ets/messageChannel/ThreadCall';

const TAG = 'MusicServiceAdapter';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);

interface MusicServiceCallback {
  isOpenAction: boolean;
  serviceRelease: Function;
  fail: Function;
}

export class MusicServiceAdapter {
  public static musicCaller: Caller | undefined = undefined;

  @threadCall(ThreadCallType.RegisterOnce)
  public static handleAbilityState(musicServiceCallback: MusicServiceCallback, tag: string): void {
    log.showInfo(`handleAbilityState ${tag}`);
    if (MusicServiceAdapter.musicCaller === undefined) {
      MusicServiceAdapter.startMusicServiceAbility(musicServiceCallback);
      return;
    }
    MusicServiceAdapter.sendCallerMessage(musicServiceCallback);
  }

  public static sendCallerMessage(musicServiceCallback: MusicServiceCallback): void {
    if (MusicServiceAdapter.musicCaller !== undefined) {
      MusicServiceAdapter.musicCaller?.call(musicServiceCallback.isOpenAction ? 'startHumSearch' : 'stopHumSearch', new MySequence('data'))
        .then(() => {
          log.showInfo('handleAbilityState Caller call() called');
        }).catch((callErr: BusinessError) => {
        log.showError(`handleAbilityState Caller.call catch error, error: ${callErr}`);
        musicServiceCallback.fail();
      });
    }
  }

  public static startMusicServiceAbility(musicServiceCallback: MusicServiceCallback): void {
    let want: Want = {
      bundleName: 'com.ohos.musicservice',
      abilityName: 'MainAbility',
      parameters: {serviceType : 'humsearch', action: 'start'}
    }
    GlobalContext.getContext().startAbilityByCall(want).then((obj) => {
      MusicServiceAdapter.musicCaller = obj;
      try {
        // 第一次启动时为了保证底层服务感知到开关状态，需要再次调用Caller接口
        MusicServiceAdapter.sendCallerMessage(musicServiceCallback);
        MusicServiceAdapter.musicCaller?.onRelease((str) => {
          log.showInfo(`handleAbilityState Caller OnRelease CallBack is called ${str}`);
          MusicServiceAdapter.musicCaller = undefined;
          musicServiceCallback.serviceRelease();
        });
      } catch (error) {
        log.showError(`caller.onRelease error, error.code: ${error.code}, error.message: ${error.message}`);
        musicServiceCallback.fail();
      }
    }).catch((err: BusinessError) => {
      log.showError(`startMusicServiceAbility GetCaller error, error: ${err}`);
      musicServiceCallback.fail();
    });
  }
}

class MySequence implements rpc.Parcelable {
  private msg?: string;

  constructor(message?: string) {
    this.msg = message;
  }

  public marshalling(dataOut: rpc.MessageSequence): boolean {
    if (!CheckEmptyUtils.isEmpty(this.msg)) {
      dataOut.writeString(this.msg)
    }
    return true;
  }

  public unmarshalling(dataIn: rpc.MessageSequence): boolean {
    if (!CheckEmptyUtils.isEmpty(dataIn)) {
      this.msg = dataIn.readString();
    }
    return true;
  }
}