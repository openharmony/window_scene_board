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
import type NtfMgr from '@ohos.notificationManager';

/**
 * 数据解析器抽象类,子类可以实现本地应用数据解析器，三方应用数据解析等
 */
export abstract class BaseDataParser<T> {
  private nextParser: BaseDataParser<T> | null = null;

  /**
   * 设置责任链的下一级数据解析器
   *
   * @param nextParser 下一级解析器
   */
  setNextParser(nextParser: BaseDataParser<T>): void {
    this.nextParser = nextParser;
  }

  /**
   * 获取下一级数据解析器
   * @returns
   */
  getNextParser(): BaseDataParser<T> | null {
    return this.nextParser;
  }

  /**
   * 解析数据
   *
   * @param request 实况通知请求
   * @param extraData 附加参数
   * @returns 解析结果
   */
  abstract parse(request: NtfMgr.NotificationRequest, extraData?: Object): T | undefined;
}