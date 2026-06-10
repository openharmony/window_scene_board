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

export abstract class CustomMessageBase {
  private visibleListener: CustomMessageListener | null = null;

  private isInitFinish = false;

  public init(listener: CustomMessageListener): boolean {
    this.visibleListener = listener;
    if (!this.isInitFinish) {
      this.isInitFinish = true;
      return this.initDiff();
    }
    return true;
  }

  protected abstract initDiff(): boolean;

  public deInit(): void {
    this.visibleListener = null;
    if (this.isInitFinish) {
      this.deInitDiff();
      this.isInitFinish = false;
    }
  }

  protected abstract deInitDiff(): void;

  protected updateVisible(visible: boolean): void {
    this.visibleListener?.updateVisible(visible);
  }

  protected addRequestPid(pid: number): void {
    this.visibleListener?.addRequestPid(pid);
  }

  protected deleteRequestPid(pid: number): void {
    this.visibleListener?.deleteRequestPid(pid);
  }
}

export interface CustomMessageListener {
  updateVisible: (visible: boolean) => void;
  addRequestPid: (pid: number) => void;
  deleteRequestPid: (pid: number) => void;
}