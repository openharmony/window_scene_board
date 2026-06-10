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

export abstract class BasePromptViewModel {

  public isShowPrompt: boolean = false;

  public prompt: string | undefined = undefined;

  public abstract showPrompt(prompt: string, promptShowType: PromptShowType, duration?: number);

  public changePrompt(remainTimes: number, freezingTime: number, isPsdFreezing: boolean) {};

  public init(defaultPrompt: Resource | undefined) {};

  public refreshVM() {};

  public countdown(remainTimes: number, freezingTime: number, isPsdFreezing: boolean, isFirst: boolean) {};

  public refreshStartTime() {};

  public checkFreezingTime() {};

  public setGetPromptCallback(callback: Function) {};

  public setGetPsdFreezingTimeCallback(callback: Function) {};

}

export enum PromptShowType {
  NONE,
  TEMPORARY,
  PERMANENT
}