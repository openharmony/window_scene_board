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
import { SCBSessionRect } from '../TsIndex';

export class SCBFoldStatePropertyChangeEvent {
  public screenId: number = -1;
  public curState: number;
  public tarState: number;
  public foldCreaseRegion: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  public bSideWidth: number = 0;
  public bSideHeight: number = 0;
  public cSideWidth: number = 0;
  public cSideHeight: number = 0;
  public rotation: number = 0;
}

Object.defineProperty(SCBFoldStatePropertyChangeEvent, 'eventTypeName', { value: 'SCBFoldStatePropertyChangeEvent' });