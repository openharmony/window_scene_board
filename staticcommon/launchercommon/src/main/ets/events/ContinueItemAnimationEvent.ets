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
import { ScreenState } from '@ohos/frameworkwrapper';

/**
 * executing continue item move animation event on three-folder device
 */
export class ContinueItemAnimationEvent {
  /**
   * event name
   */
  public static readonly eventTypeName: string = 'ContinueItemAnimationEvent';
  public curTripleFoldState: ScreenState = ScreenState.F;
  public lastTripleFoldState: ScreenState = ScreenState.F;

  constructor(oldState: ScreenState, newState: ScreenState) {
    this.lastTripleFoldState = oldState;
    this.curTripleFoldState = newState;
  }
}