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
import { image } from '@kit.ImageKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CustomPromise } from '@ohos/frameworkwrapper';
import lazy { messageChannel } from '../messageChannel/MessageChannel';
import { Singleton } from '../utils/Singleton';
import { sharedData } from '../model/SendableData';

const TAG = 'AodSnapshotAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export interface SnapShotResult {
  id: string;
  image: image.PixelMap;
}

/**
 * Defines the rect property.
 */
export interface ComponentRect {
  left: number;
  right: number;
  top: number;
  bottom: number;
}

export class AodSnapshotAdapter {
  private promiseMap = new Map<string, CustomPromise<void>>();
  private resultMap = new Map<string, image.PixelMap>();
  @Singleton.decorate()
  public static get instance(): AodSnapshotAdapter {
    return new AodSnapshotAdapter();
  }

  public init() {
    messageChannel.onMessage('recvSnapshot', (snapshot: SnapShotResult) => {
      this.resultMap.set(snapshot.id, snapshot.image);
      this.promiseMap.get(snapshot.id)?.resolve();
      this.promiseMap.delete(snapshot.id);
    })
  }

  public async getSnapShot(id: string): Promise<image.PixelMap> {
    messageChannel.sendMessage('startSnapshot', id);
    const snapshotPromise = new CustomPromise<void>();
    this.promiseMap.set(id, snapshotPromise);
    await snapshotPromise;
    let result = this.resultMap.get(id)!;
    result.getImageInfo().then((info) => {
      log.showInfo(`recieve snapshot, w: ${info.size.width}, h: ${info.size.height}`);
    })
    this.resultMap.delete(id);
    return result;
  }

  public getRect(componentId: string): ComponentRect {
    if (componentId === sharedData.aodNtfId) {
      return sharedData.aodNtfRect.convert2LRTBRect();
    }
    if (componentId === sharedData.aodCapsuleId) {
      return sharedData.aodCapsuleRect.convert2LRTBRect()
    }
    return { left: 0, top: 0, right: 0, bottom: 0 };
  }
}
