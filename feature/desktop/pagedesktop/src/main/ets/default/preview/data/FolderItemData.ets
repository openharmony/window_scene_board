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

/**
 * 文件夹数据
 */
@Observed
export class FolderItemData {
  private _imageUri: string = '';

  private _mFolderName: string = '';

  private _isSmallFolder: boolean = false;

  private _imageWidth: number = 64;

  private _imageHeight: number = 64;

  public set imageUri(value: string) {
    this._imageUri = value;
  }

  public get imageUri(): string {
    return this._imageUri;
  }

  public set mFolderName(value: string) {
    this._mFolderName = value;
  }

  public get mFolderName(): string {
    return this._mFolderName;
  }

  public set isSmallFolder(value: boolean) {
    this._isSmallFolder = value;
  }

  public get isSmallFolder(): boolean {
    return this._isSmallFolder;
  }

  public set imageWidth(value: number) {
    this._imageWidth = value;
  }

  public get imageWidth(): number {
    return this._imageWidth;
  }

  public set imageHeight(value: number) {
    this._imageHeight = value;
  }

  public get imageHeight(): number {
    return this._imageHeight;
  }
}