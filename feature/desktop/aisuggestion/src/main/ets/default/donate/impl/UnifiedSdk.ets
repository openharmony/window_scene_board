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
// import { BaseSdkPresenter, FetchDataResult } from '@ohos-aidispatch/abilitybasesdkoh';
// import type { DispatchParams } from '@ohos-aidispatch/abilitybasesdkoh/src/main/ets/beans/DispatchParams';
// import { JsonUtil } from '@ohos-aidispatch/abilitybasesdkoh/src/main/ets/utils/JsonUtil';
import type common from '@ohos.app.ability.common';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { DispatchParamsConstant } from '../../constants/DispatchParamsConstant';
import type { IUnifiedSdk } from '../IUnifiedSdk';

const TAG: string = 'UnifiedSdk';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const WAIT_TIME: number = 60;
const TOTAL_WAIT_TIME: number = WAIT_TIME * 1000;

/**
 * 统一SDK接口实现
 *
 * @since 2023-08-11
 */
export class UnifiedSdk implements IUnifiedSdk {
  private static sInstance: UnifiedSdk = new UnifiedSdk();

  private mTimerId: number = -1;

  private constructor() {
  }

  /**
   * Get instance
   *
   * @return Single instance
   */
  static getInstance(): UnifiedSdk {
    return UnifiedSdk.sInstance;
  }

  connect(context: common.UIAbilityContext | common.ServiceExtensionContext): Promise<void> {
    return new Promise((resolve, reject) => {
      // BaseSdkPresenter.getInstance().create(context, `["${DispatchParamsConstant.SERVICE_NAME}"]`, {
      //   onResult: (retCode: number, callbackResult: string) => {
      //     if (retCode === 1) {
      //       resolve();
      //       return;
      //     }
      //     reject(new Error(`connect fail retCode = ${retCode}, ret = ${callbackResult}`));
      //   }
      // });
    });
  }

  disconnect(): void {
    this.cancelTimer();
    this.mTimerId = setTimeout(() => {
      // BaseSdkPresenter.getInstance().release(`["${DispatchParamsConstant.SERVICE_NAME}"]`);
    }, TOTAL_WAIT_TIME);
  }

  private cancelTimer(): void {
    if (this.mTimerId > 0) {
      clearTimeout(this.mTimerId);
      this.mTimerId = -1;
    }
  }

  async dispatch(dispatchParams: ESObject): Promise<object> {
    this.cancelTimer();
    return new Promise((resolve, reject) => {
      this.connect(GlobalContext.getContext()).then(() => {
        // log.showError(`dispatch = ${JsonUtil.parseObjToStr(dispatchParams?.content?.contentData[0])}`);
        // BaseSdkPresenter.getInstance()
        //   .dispatchMessage(DispatchParamsConstant.SERVICE_NAME, JsonUtil.parseObjToStr(dispatchParams), {
        //     onResult: (retCode: number, callbackResult: string) => {
        //       log.showInfo(`onResult code = ${retCode}, ret = ${callbackResult?.length}`);
        //       const ret = JSON.parse(callbackResult) as DispatchParams;
        //       resolve(ret?.content?.contentData[0]?.payload);
        //       this.disconnect();
        //     }
        //   });
        resolve(new Object("a"));
      }).catch((err: Error) => {
        log.showError(`connect occurs error = ${err?.message}`);
        this.disconnect();
        reject(err);
      });
    });
  }
}