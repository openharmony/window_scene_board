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
import { LiveButtonArray, LiveButtonData } from '../../../data/extend/LiveButtonData';
import { ProgressNodeComponent } from './ProgressNodeComponent';
import { LiveProgressTemplate } from '../../../data/template/LiveProgressTemplate';
import { CardUtils } from '../LiveViewCardData';

/**
 * 扩展区为进度可视化模板组件：进度条节点数组
 */
@Component
export struct ProgressNodeArrayComponent {
  @ObjectLink data: LiveProgressTemplate;
  @ObjectLink nodeIcons: LiveButtonArray;
  @Link iconWidth: number;

  build() {
    if ((this.nodeIcons?.length ?? 0) >= CardUtils.MIN_ICON_LENGTH) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.nodeIcons, (nodeIcon: LiveButtonData, index: number) => {
          Row() {
            ProgressNodeComponent({ nodeIcon: nodeIcon })
          }
          .width('20vp')
          .height('20vp')
          .clip(true)
          .borderRadius(10)
          .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
            this.updateIconWidth(newValue?.width as number);
          })
          .backgroundColor(this.getBackgroundColor(index))
        })
      }
      .layoutWeight(1)
    }
  }

  private updateIconWidth(width: number | undefined) {
    if (!width || !this.nodeIcons?.length) {
      return;
    }
    this.iconWidth = width;
  }

  private getBackgroundColor(index: number): ResourceColor {
    let length: number | undefined = this.nodeIcons?.length;
    if (!length || length < CardUtils.MIN_ICON_LENGTH) {
      return this.data?.color ?? CardUtils.OTHER_PROGRESS_COLOR;
    }
    let progress: number = this.data?.progress ?? 0;
    if (progress >= CardUtils.MAX_PROGRESS) {
      return this.data?.color ?? CardUtils.OTHER_PROGRESS_COLOR;
    }
    let gap: number = CardUtils.MAX_PROGRESS / (length - 1);
    if (progress >= index * gap) {
      return this.data?.color ?? CardUtils.OTHER_PROGRESS_COLOR;
    }
    return this.data?.backgroundColor ?? CardUtils.OTHER_PROGRESS_BLACK_COLOR;
  }
}