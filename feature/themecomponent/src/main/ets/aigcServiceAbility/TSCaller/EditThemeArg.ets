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
import { ThemeOptions } from './ThemeOptions';

/**
 * 编辑主题参数
 */
export type From = 'gallery' | 'Personalize' | 'Pandora';

export class EditThemeArg {
  public editorId: string;
  public customPath?: string;
  public option?: ThemeOptions;
  public activate: boolean = true;
  public from: From;
  public isUsable: boolean = true;

  constructor(editorId: string, from: From) {
    this.editorId = editorId;
    this.from = from;
  }
}