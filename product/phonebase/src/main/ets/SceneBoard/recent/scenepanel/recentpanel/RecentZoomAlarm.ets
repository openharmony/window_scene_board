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

import { SCBSceneContainerSession } from '@ohos/windowscene';
import { CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { Alarm } from '@ohos/componenthelper';
import { curves } from '@kit.ArkUI';

const TAG = 'RecentZoomAlarm';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentZoomAlarm {
  private readonly DELAY_TIME: number = 50;
  private alarm: Alarm;
  private scaleX: number = 1.0;
  private scaleY: number = 1.0;
  private sceneContainerSession: SCBSceneContainerSession | null = null;

  constructor() {
    this.alarm = new Alarm();
    this.alarm.setHandler({
      onAlarm: () => {
        this.onAlarm();
      }
    });
  }

  private onAlarm(): void {
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 240, 28)
    }, () => {
      this.sceneContainerSession?.needRenderTitleViewScale.setTitleViewScale(0.95);
      this.sceneContainerSession?.needRenderScale.setScaleXWithDfx(this.scaleX * 0.95, TAG, 'touchDown',
        this.sceneContainerSession.getName());
      this.sceneContainerSession?.needRenderScale.setScaleYWithDfx(this.scaleY * 0.95, TAG, 'touchDown',
        this.sceneContainerSession.getName());
    })
  }

  public static getInstance(): RecentZoomAlarm {
    return SingletonHelper.getInstance(RecentZoomAlarm, TAG);
  }

  public start(sceneContainerSession: SCBSceneContainerSession | null): void {
    log.showInfo('start recent zoom alarm');
    this.sceneContainerSession = sceneContainerSession;
    this.initScaleForDownAnimation();
    this.alarm.setAlarm(this.DELAY_TIME);
    this.alarm.run();
  }

  public cancel(reason?: string): void {
    log.showInfo('cancel recent zoom alarm, reason: ' + reason);
    this.alarm.cancelAlarm();
  }

  private initScaleForDownAnimation(): void {
    if (this.sceneContainerSession) {
      this.scaleX = this.sceneContainerSession.needRenderScale.scaleX;
      this.scaleY = this.sceneContainerSession.needRenderScale.scaleY;
    }
  }

  public restoreScale(): void {
    this.scaleX = 1.0;
    this.scaleY = 1.0;
  }

  public cancelCallback(): void {
    if (CommonUtils.equals(this.scaleX, 1)) {
      return;
    }
    let scaleX = this.scaleX;
    let scaleY = this.scaleY;
    this.restoreScale();
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 157.9, 23.9)
    }, () => {
      this.sceneContainerSession?.needRenderTitleViewScale.setTitleViewScale(1);
      this.sceneContainerSession?.needRenderScale.setScaleXWithDfx(scaleX, TAG, 'touchUp',
        this.sceneContainerSession.getName());
      this.sceneContainerSession?.needRenderScale.setScaleYWithDfx(scaleY, TAG, 'touchUp',
        this.sceneContainerSession.getName());
    })
  }
}