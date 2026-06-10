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
  BasePromptViewModel,
  PromptShowType
} from '@ohos/screenlockcomponent/src/main/ets/fingerprint/BasePromptViewModel';
import Constants from '../common/Constants';

// 这里类主要是维护tip，需要知道是主动还是被动刷新tips，以及tips显示优先级
export class PCBasePromptViewModel extends BasePromptViewModel {
  // 记录用户进行过主动尝试行为
  public haveTryUnlock: boolean = false;
  // 记录用户主动尝试行为导致的tip刷新
  public userRetry: boolean = false;

  public showPrompt(prompt: string, promptShowType: PromptShowType, duration?: number) {
  };

  public setPromptByUserBehavior(prompt: string): void {
    this.prompt = prompt;
    this.isShowPrompt = true;
    this.haveTryUnlock = true;
    this.userRetry = true;
  }
}

