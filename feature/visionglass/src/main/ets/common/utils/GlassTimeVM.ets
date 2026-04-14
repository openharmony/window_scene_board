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
import { DateTimeVM } from '@ohos/customcomponent/src/main/ets/vm/DateTimeVM';

/**
 * 通知时间戳VM
 *
 * @since 2024-05-09
 */
export class GlassTimeVM {
  /**
   * 时间文本
   */
  public timeText: string = '';
  private dateTimeVm: DateTimeVM = new DateTimeVM();

  onTimeTextUpdate(timeText: string) {
    this.timeText = timeText;
  };

  init(timeMillis: number, note: string) {
    this.dateTimeVm.initOv(timeMillis, note, this);
  }

  deinit() {
    this.dateTimeVm.onDestroy();
  }

  update(timeMillis: number) {
    this.dateTimeVm.updateOvTimeMillis(timeMillis);
  }
}