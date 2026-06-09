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
import { DockItemInfo } from '@ohos/launchercommon';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';
import { IconType, PerceptionSceneType, IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { CollaborationEvent } from '@ohos/smartdock/src/main/ets/default/common/component/CollaborationEvent';
import { SCBSceneContainerSession } from '@ohos/windowscene';

const TAG = 'CarControlNotify';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 处理图片信息
 */
export class CarControlNotify implements IExecutor {
  private readonly BUSINESS_EXIT = 1;
  private readonly BUSINESS_IN = 0;
  private dataMap = 'dataMap';
  private imageInfo = 'imageInfo';
  private heartType = 'heartType';
  private perceptionType = 'perceptionType';
  public static item: DockItemInfo = {
    bundleName: 'com.ohos.cardistributedassist',
    abilityName: 'MainUiAbility',
    visible: false,
    borderVisible: false,
    shake: 0,
    appName: '出行分布式业务助手',
    missionInfoList: SCBSceneContainerSession[0],
    appIconId: 0,
    appIndex: 0,
    image: '',
    perceptionSceneType: PerceptionSceneType.CAR_SCENE,
    iconType: IconType.CAR
  };

  /**
   * get single instance of CarControlNotify
   *
   * @param perceptionType 进场 or 退场
   */
  public static changeCollaboration( perceptionType: number): void {
    CollaborationEvent.changeServiceList(perceptionType, CarControlNotify.item);
  }

  async execute(extra?: object): Promise<string> {
    if (!extra) {
      return Response.FAIL;
    }
    let carControlImage: string = extra[this.dataMap][this.imageInfo];
    let carControlEvent: number = extra[this.dataMap][this.heartType];
    log.showInfo(`carControlEvent = ${carControlEvent}`);
    let perceptionType: number = extra[this.perceptionType];
    CarControlNotify.item.image = carControlImage;
    if (carControlEvent === this.BUSINESS_IN) {
      AppStorage.setOrCreate('Base64Image', carControlImage as string);
      CarControlNotify.changeCollaboration(perceptionType);
      return JSON.stringify('send message success');
    } else {
      CarControlNotify.changeCollaboration(this.BUSINESS_EXIT);
      return JSON.stringify('send heart success');
    }
  }
}