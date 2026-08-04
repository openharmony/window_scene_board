/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
import { image } from '@kit.ImageKit';
import { IBuilderSnapshot } from './IBuilderSnapshot';

/**
 * 离屏渲染图片组件截图抽象层
 */
export interface IImageSnapshot extends IBuilderSnapshot<image.PixelMap> {
}