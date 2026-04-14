/*
 *
 *  * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 *  * Licensed under the Apache License, Version 2.0 (the "License");
 *  * you may not use this file except in compliance with the License.
 *  * You may obtain a copy of the License at
 *  *
 *  *     http://www.apache.org/licenses/LICENSE-2.0
 *  *
 *  * Unless required by applicable law or agreed to in writing, software
 *  * distributed under the License is distributed on an "AS IS" BASIS,
 *  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  * See the License for the specific language governing permissions and
 *  * limitations under the License.
 *
 */

import type { SCBSceneContainerSession } from '@ohos/windowscene';
import type Image from '@ohos.multimedia.image';

export class SnapshotInfo {
  public name: string = '';
  public image?: Image.PixelMap;
  public missionId: number = 0;
  public boxSize: number = 0;
  public bundleName: string = '';
  public appLabelId: number = 0;
  public left?: number;
  public right?: number;
  public sceneSession?: SCBSceneContainerSession;
  public shortcutId?: string;
  public nodeType?: number;
}