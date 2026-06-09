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
import { Log } from "../utils/Log";
import { SubscribeUtil } from "../utils/SubscribeUtil";


const TAG: string = 'EngineService-LocationSubscriber';
const DURATION: number = 5000;
const REFRESH_TIME: number = 30 * 60 * 1000; // half an hour

/**
 * Location refresh Subscriber.
 *
 * @since 2024-08-30
 */
export class LocationSubscriber {
  public isNeedRefresh: boolean = false;

  private timer: number | null = null;
  private eventArr: string[] = ['usual.event.TIME_TICK'];
  private subscribeUtil: SubscribeUtil = new SubscribeUtil(this.eventArr);
  private recordTimeStamp: number = -1;

  public constructor() {
    clearTimeout(this.timer);
    this.subscribeUtil.concealSubscribe();
    this.recordTimeStamp = new Date().getTime();
  }

  /**
   * Start subscribe on the hour to refresh location.
   */
  public initSubscriber(): void {
    this.subscribeUtil.initSubscriber().then(() => {
      this.subscribeUtil.eventSubscribe(() => {
        // Triggered half an hour.
        let curTimeStamp: number = new Date().getTime();
        if ((curTimeStamp - this.recordTimeStamp) <= REFRESH_TIME) {
          return;
        }
        this.isNeedRefresh = true;
        Log.info(TAG, `handleRefreshData = ${this.isNeedRefresh}`);
        this.cancelRefreshData();
      });
    }).catch(() => {
      Log.error(TAG, 'Failed to create subscriber.');
    });
  }

  private cancelRefreshData(): void {
    this.timer = setTimeout(() => {
      this.recordTimeStamp = new Date().getTime();
      this.isNeedRefresh = false;
      Log.info(TAG, `cancelRefreshData = ${this.isNeedRefresh}`);
      if (this.timer !== null) {
        clearTimeout(this.timer);
        this.timer = null;
      }
    }, DURATION)
  }
}