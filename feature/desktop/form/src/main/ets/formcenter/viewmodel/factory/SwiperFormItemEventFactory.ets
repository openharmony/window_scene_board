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

import { AppItemInfo, CardItemInfo } from '@ohos/launchercommon';
import { FormItemEventInterface } from '../../interfaces/FormItemEventInterface';
import { SwiperScreenLockFormItemEvent } from '../event/FormItemEvent/SwiperScreenLockFormItemEvent';
import { SwiperLayoutFormEvent } from '../event/FormItemEvent/SwiperLayoutFormEvent';
import { AttributeUpdater } from '@kit.ArkUI';
import { SwiperFormAnimate } from '../event/swiperlayoutevent/SwiperAnimateViewModel';

interface SwiperFormItemEventParam {
  isScreenLock: boolean;
  formItem: CardItemInfo;
  index: number;
  appItem: AppItemInfo;
  isCurrentIndex: (index: number) => boolean,
  setCardId: (index: number, cardId: string) => void,
  swiperFormAnimate: SwiperFormAnimate,
  setParentUpdater?: (index: number, parentUpdater: AttributeUpdater<CommonAttribute>,
    formModifier: AttributeUpdater<CommonAttribute>) => void,
}

export class SwiperFormItemEventFactory {
  public static createFormItemEvent(param: SwiperFormItemEventParam): FormItemEventInterface {
    if (param.isScreenLock) {
      return new SwiperScreenLockFormItemEvent(param.formItem, param.index, param.appItem, param.isCurrentIndex,
        param.setCardId, param.swiperFormAnimate, param.setParentUpdater);
    }
    return new SwiperLayoutFormEvent(param.formItem, param.index, param.appItem, param.isCurrentIndex, param.setCardId,
      param.swiperFormAnimate, param.setParentUpdater);
  }
}