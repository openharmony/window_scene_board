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

export class SwiperItem {
  /**
   * lottie加载次数
   */
  public loadCount: number = 0;
  /**
   * 下标
   */
  public index: number = 0;
  /**
   * swiperItem名称
   */
  public name: string = '';
  /**
   * swiper资源功能
   */
  public function?: ResourceStr;
  /**
   * swiper资源详情
   */
  public detail?: ResourceStr;
  /**
   * 是否正在播放
   */
  public isPlaying: boolean = false;
}