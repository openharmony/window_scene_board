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

const TAG = 'ImageIconModifier';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);


export class ImageIconModifier extends AttributeUpdater<ImageAttribute, ImageInterface> {

  private id: string = ';'
  private contentColor?: string;
  private imageSrc?: PixelMap | ResourceStr | DrawableDescriptor;

  constructor(id?: string) {
    super();
    this.id = id ?? '';
  }

  public modifyContentColor(contentColor: string): void {
    log.info(`modify(${this.id}) content color from ${this.contentColor} to ${contentColor} `);
    this.contentColor = contentColor;
    if (!this.attribute) {
      log.showError(`modify(${this.id}) content color updater attribute is invlid.`);
      return;
    }
    this.attribute.fillColor(this.contentColor);
  }

  public initImageSrc(imageSrc: PixelMap | ResourceStr | DrawableDescriptor): ImageIconModifier {
    this.imageSrc = imageSrc;
    return this;
  }

  public getImageSrc(): PixelMap | ResourceStr | DrawableDescriptor | undefined {
    return this.imageSrc;
  }

  public initContentColor(contentColor: string): ImageIconModifier {
    log.info(`set(${this.id}) content color from ${this.contentColor} to ${contentColor}`);
    this.contentColor = contentColor;
    return this;
  }

  public modifyImageSrc(imageSrc: PixelMap | ResourceStr | DrawableDescriptor): void {
    log.debug(`modify(${this.id}) image source.`);
    this.imageSrc = imageSrc;
    this.updateConstructorParams(this.imageSrc);
  }

  /**
   * 组件build的时候会执行
   */
  initializeModifier(instance: ImageAttribute): void {
    log.info(`initialize(${this.id}) modifier content color(${this.contentColor})`);
    if (this.contentColor !== undefined) {
      instance.fillColor(this.contentColor);
    }
  }
}
