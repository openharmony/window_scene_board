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
/**
 * 下载模板条目数据处理
 *
 * @since 2023-01-14
 */
export class NtfDownloadItemVM {
  /**
   * 回调器
   */
  private callback: DownloadItemCallback | null = null;

  init(callback: DownloadItemCallback): void {
    this.callback = callback;
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    this.callback = null;
  }

  /**
   * 设置条目hover状态
   *
   * @param isHover 是否hover
   */
  setItemHoverState(isHover: boolean): void {
    this.callback?.onItemHoverChange(isHover);
  }
}

/**
 * 下载模板回调器
 */
export interface DownloadItemCallback {
  /**
   * 条目hover状态回调
   *
   * @param isHovered 是否hover
   */
  onItemHoverChange(isHovered: boolean): void;
}