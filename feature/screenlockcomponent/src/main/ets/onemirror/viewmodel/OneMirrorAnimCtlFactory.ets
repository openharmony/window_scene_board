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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import OneMirrorAnimController from './OneMirrorAnimController'
import OneMirrorAnimControllerFull from './OneMirrorAnimControllerFull';
import OneMirrorAnimControllerPart from './OneMirrorAnimControllerPart';
import OneMirrorAnimControllerPartEmoji from './OneMirrorAnimControllerPartEmoji';

export enum OneMirrorAnimCtlType {
  NO_MIRROR,
  ONE_MIRROR_FULL,
  ONE_MIRROR_PART,
  ONE_MIRROR_PART_EMOJI,
}

const TAG = 'OneMirrorAnimCtlFactory';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class OneMirrorAnimCtlFactory {
  private ctlMap: Map<OneMirrorAnimCtlType, OneMirrorAnimController> = new Map();

  constructor() {
    this.ctlMap.set(OneMirrorAnimCtlType.ONE_MIRROR_FULL, new OneMirrorAnimControllerFull());
    this.ctlMap.set(OneMirrorAnimCtlType.ONE_MIRROR_PART, new OneMirrorAnimControllerPart());
    this.ctlMap.set(OneMirrorAnimCtlType.NO_MIRROR, new OneMirrorAnimController());
    this.ctlMap.set(OneMirrorAnimCtlType.ONE_MIRROR_PART_EMOJI, new OneMirrorAnimControllerPartEmoji());
  }

  /**
   * 根据type获取OneMirrorAnimController对象
   * @param type OneMirrorAnimCtlType
   * @returns OneMirrorAnimController
   */
  public getMirrorControllerByType(type: OneMirrorAnimCtlType): OneMirrorAnimController {
    return this.ctlMap.get(type) ?? this.getMirrorController();
  }

  /**
   * 根据是否是局部AOD来创建一镜到底Controller
   * 由内部根据具体场景来
   * @returns OneMirrorAnimController
   */
  public getMirrorController(): OneMirrorAnimController {
    return this.ctlMap.get(OneMirrorAnimCtlType.NO_MIRROR) ?? new OneMirrorAnimController();
  }
}