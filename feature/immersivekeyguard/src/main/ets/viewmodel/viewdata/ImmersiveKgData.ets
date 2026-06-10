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
import type { IUpdatable } from '@ohos/systemuicommon';
import {
  ImmersiveKgParserCtrlType
} from '@ohos/systemuicommon';
import {
  ParseResultType
} from '@ohos/systemuicommon';
import type {
  IComponentData
} from '@ohos/systemuicommon';
import { CommonUtils } from '@ohos/basicutils';

/**
 * 沉浸锁屏数据类型
 */
@Observed
export class ImmersiveKgData implements IComponentData, IUpdatable {
  /**
   * 复写IResult，数据解析结果
   */
  public resultType: ParseResultType = ParseResultType.MISS;

  /**
   * 沉浸胶囊标题
   */
  public title?: string;

  /**
   * 沉浸胶囊内容
   */
  public content?: string;

  /**
   * 复写IComponentData
   *
   * @returns 数据名
   */
  getDataName(): string {
    return ImmersiveKgParserCtrlType.TYPE_IMMERSIVE_KG;
  }

  /**
   * 复写 IUpdatable
   *
   * @param other 更新数据来源
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof ImmersiveKgData)) {
      return;
    }
    let otherData = other as ImmersiveKgData;
    this.setTitle(otherData?.title, forceRefresh);
    this.setContent(otherData?.content, forceRefresh);
  }

  /**
   * 设置标题文本
   *
   * @param title 标题
   * @param forceRefresh 是否强制刷新
   */
  setTitle(title?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(title)) {
      this.title = title;
    }
  }

  /**
   * 设置内容文本
   *
   * @param content 内容
   * @param forceRefresh 是否强制刷新
   */
  setContent(content?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(content)) {
      this.content = content;
    }
  }
}