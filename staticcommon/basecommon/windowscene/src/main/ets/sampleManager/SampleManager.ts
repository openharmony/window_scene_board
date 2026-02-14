
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
import { SingletonHelper } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SampleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


export class SampleManager {
  private checkFunc: Function;
  private isSampleMg: boolean = false;

  public dominateScreen(sampleMg: boolean): void {
    this.isSampleMg = sampleMg;
  }

  public registerCheckFunction(func: Function): void {
    this.checkFunc = func;
  }

  public isTrustlistForWms(bundleName: string, moduleName: string, abilityName: string): boolean {
    if (!this.checkFunc) {
      return false;
    }
    return this.checkFunc(bundleName, moduleName, abilityName);
  }
  public isSampleManagerChecked(): boolean {
    log.showInfo('isSampleMg: %{public}s', this.isSampleMg);
    return this.isSampleMg;
  }
}

let sSampleManager = SingletonHelper.getInstance(SampleManager, TAG);

export default sSampleManager as SampleManager;