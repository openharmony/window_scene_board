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

import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBRecentStyle, SCBRecentStyleManager } from './SCBRecentStyle';
import { AnimationType, SCBRecentFoldMachineVM, CustomAnimateParam } from './SCBRecentFoldMachineVM';

const TAG = 'Recent-SCBRecentFoldPhysicalVM';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * 折叠机物理键盘态
 */
export class SCBRecentFoldPhysicalVM extends SCBRecentFoldMachineVM {

  protected static instance: SCBRecentFoldPhysicalVM;

  protected scrollAnimationParam: CustomAnimateParam = {
    duration: 150,
    curve: Curve.Sharp
  }
  protected bcAnimationParam: CustomAnimateParam = {
    duration: 700,
    curve: curves.springCurve(0, 7, 50, 30),
  }

  public static getInstance(): SCBRecentFoldPhysicalVM {
    if (!SCBRecentFoldPhysicalVM.instance) {
      SCBRecentFoldPhysicalVM.instance = new SCBRecentFoldPhysicalVM();
    }
    return SCBRecentFoldPhysicalVM.instance;
  }

  public runAnimation(key: AnimationType, screenID: number, param?: CustomAnimateParam | undefined): void {
    super.executeAnimation(key, screenID, param);
  }
}