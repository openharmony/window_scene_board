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
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'Recent-SCBRecentFoldMachineVM';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);


export class SCBRecentFoldMachineVM {
  public static animationMap: Map<string, Callback<CustomAnimateParam, void>> = new Map();

  protected static instance: SCBRecentFoldMachineVM;

  public static getInstance(): SCBRecentFoldMachineVM {
    if (!SCBRecentFoldMachineVM.instance) {
      SCBRecentFoldMachineVM.instance = new SCBRecentFoldMachineVM();
    }
    return SCBRecentFoldMachineVM.instance;
  }

  public runAnimation(key: AnimationType, screenID: number, param?: CustomAnimateParam): void {};

  protected executeAnimation(key: AnimationType, screenID: number, param?: CustomAnimateParam): void {
    if (!param) {
      param = { duration: 0, curve: Curve.Linear };
    }
    SCBRecentFoldMachineVM.animationMap.get(`${key}_${screenID}`)?.(param);
  };

  public registerAnimation(key: AnimationType, screenID: number, animation: Callback<CustomAnimateParam>): void {
    SCBRecentFoldMachineVM.animationMap.set(`${key}_${screenID}`, animation);
  }

  public unregisterAnimation(key: AnimationType, screenID: number): void {
    SCBRecentFoldMachineVM.animationMap.delete(`${key}_${screenID}`);
  }
}

export interface CustomAnimateParam extends AnimateParam {
  animationKey?: string,
  needUpdateStack?: boolean;
  yOffset?: number;
}

export enum AnimationType {

  AVOID_KEYBOARD = 'avoidKeyboard',
  AVOID_ANIMATION = 'avoidAnimation',
  SCROLL_ANIMATION = 'ScrollAnimation',
  FOLD_ANIMATION = 'foldAnimation'
}