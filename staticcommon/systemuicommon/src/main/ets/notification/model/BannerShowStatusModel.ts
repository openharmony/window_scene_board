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
import { messageChannel } from '../../messageChannel/MessageChannel';
import { Singleton } from '../../utils/Singleton';

/**
 * 实况横幅显示事件
 */
export class LiveHeadsUpShowEvent {
  /**
   * 横幅显示
   */
  static readonly EVENT_SHOW_BANNER = 'show_banner';
  /**
   * 横幅隐藏
   */
  static readonly EVENT_HIDE_BANNER = 'hide_banner';

  public headUpStatus: string = '';
}

Object.defineProperty(LiveHeadsUpShowEvent, 'eventTypeName', { value: 'LiveHeadsUpShowEvent' });

@ObservedV2
export class BannerShowStatusModel {
  @Singleton.decorate() static get instance(): BannerShowStatusModel { return new BannerShowStatusModel(); }
  @Trace isShow: boolean = true;

  public initAdapter(): void {
    messageChannel.onMessage('bannerShowStatusModel', (isShow: boolean) => {
      this.isShow = isShow;
    });
  }

  public updateShowStatus(isShow: boolean): void {
    this.isShow = isShow;
  }
}
