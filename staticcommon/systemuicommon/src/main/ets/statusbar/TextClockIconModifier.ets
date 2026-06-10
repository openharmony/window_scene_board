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
import { AttributeUpdater } from '@ohos.arkui.modifier';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'TextClockIconModifier';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);


export class TextClockIconModifier extends AttributeUpdater<TextClockAttribute, TextClockInterface> {

  private id: string = ';'
  private contentColor?: ResourceColor;

  constructor(id?: string) {
    super();
    this.id = id ?? '';
  }

  public modifyContentColor(contentColor: ResourceColor): void {
    log.showInfo(`modify(${this.id}) content color from ${this.contentColor} to ${contentColor} `);
    this.contentColor = contentColor;
    if (!this.attribute) {
      log.showError(`modify(${this.id}) content color updater attribute is invlid.`);
      return;
    }
    this.attribute.fontColor(this.contentColor);
  }

  public initContentColor(contentColor: ResourceColor): TextClockIconModifier {
    log.showInfo(`set(${this.id}) content color from ${this.contentColor} to ${contentColor}`);
    this.contentColor = contentColor;
    return this;
  }

  /**
   * 组件build的时候会执行
   */
  initializeModifier(instance: TextClockAttribute): void {
    log.showInfo(`initialize(${this.id}) modifier content color(${this.contentColor})`);
    if (this.contentColor !== undefined) {
      instance.fontColor(this.contentColor);
    }
  }
}
