import { image } from '@kit.ImageKit'
import { fileIo } from '@kit.CoreFileKit'
import { ImageShowStyle } from '../pages/ShowWallpaperPage'

/**
 * 图片适配器 - 完整版（包含平铺）
 */
class CompleteImageAdapter {

  /**
   * 适配图片并保存
   * @param imagePath 输入图片路径
   * @param fitMode 适配模式：cover/contain/fill/none/tile
   * @param targetWidth 目标宽度
   * @param targetHeight 目标高度
   */
  static async adaptImage(imagePath: string, fitMode: ImageShowStyle, targetWidth: number, targetHeight: number): Promise<PixelMap> {
    try {
      const file = fileIo.openSync(imagePath, fileIo.OpenMode.READ_ONLY)
      const imageSource = image.createImageSource(file.fd)
      const imageInfo = await imageSource.getImageInfo()
      const srcWidth = imageInfo.size.width
      const srcHeight = imageInfo.size.height
      let pixelMap: PixelMap

      if (fitMode === ImageShowStyle.ImageShowStyleTileScreen) {
        // ========== 平铺模式 ==========
        pixelMap = await CompleteImageAdapter.createTilePixelMap(imageSource, srcWidth, srcHeight, targetWidth, targetHeight)

      } else if (fitMode === ImageShowStyle.ImageShowStyleFullScreen) {
        // ========== Cover 模式 ==========
        const scale = Math.max(targetWidth / srcWidth, targetHeight / srcHeight)
        const decodeWidth = Math.floor(srcWidth * scale)
        const decodeHeight = Math.floor(srcHeight * scale)

        const decodingOptions: image.DecodingOptions = {
          desiredSize: { width: decodeWidth, height: decodeHeight },
          desiredPixelFormat: image.PixelMapFormat.RGBA_8888
        }
        pixelMap = await imageSource.createPixelMap(decodingOptions)

      } else if (fitMode === ImageShowStyle.ImageShowStyleFitScreen) {
        // ========== Contain 模式 ==========
        const scale = Math.min(targetWidth / srcWidth, targetHeight / srcHeight)
        const decodeWidth = Math.floor(srcWidth * scale)
        const decodeHeight = Math.floor(srcHeight * scale)

        const decodingOptions: image.DecodingOptions = {
          desiredSize: { width: decodeWidth, height: decodeHeight },
          desiredPixelFormat: image.PixelMapFormat.RGBA_8888
        }
        pixelMap = await imageSource.createPixelMap(decodingOptions)

      } else if (fitMode === ImageShowStyle.ImageShowStyleStretchScreen) {
        // ========== Fill 模式 ==========
        const decodingOptions: image.DecodingOptions = {
          desiredSize: { width: targetWidth, height: targetHeight },
          desiredPixelFormat: image.PixelMapFormat.RGBA_8888
        }
        pixelMap = await imageSource.createPixelMap(decodingOptions)

      } else {
        // ========== None 模式 ==========
        const decodingOptions: image.DecodingOptions = {
          desiredSize: { width: srcWidth, height: srcHeight },
          desiredPixelFormat: image.PixelMapFormat.RGBA_8888
        }
        pixelMap = await imageSource.createPixelMap(decodingOptions)
      }
      fileIo.closeSync(file)
      return pixelMap

    } catch (err) {
      return err
    }
  }

  /**
   * 创建平铺 PixelMap（使用带 PositionArea 参数的 readPixels）
   */
  private static async createTilePixelMap(imageSource: image.ImageSource, srcWidth: number, srcHeight: number, targetWidth: number, targetHeight: number): Promise<PixelMap> {
    const decodingOptions: image.DecodingOptions = {
      desiredSize: { width: srcWidth, height: srcHeight },
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    }
    const sourcePixelMap = await imageSource.createPixelMap(decodingOptions)
    const area: image.PositionArea = {
      pixels: new ArrayBuffer(srcWidth * srcHeight * 4),
      offset: 0,
      stride: srcWidth * 4,
      region: {
        x: 0,
        y: 0,
        size: {
          width: srcWidth,
          height: srcHeight
        }
      }
    }

    await sourcePixelMap.readPixels(area)
    const sourcePixels = new Uint8Array(area.pixels)
    const targetBuffer = new ArrayBuffer(targetWidth * targetHeight * 4)
    const targetPixels = new Uint8Array(targetBuffer)
    for (let targetY = 0; targetY < targetHeight; targetY++) {
      for (let targetX = 0; targetX < targetWidth; targetX++) {
        // 使用取模运算实现平铺
        const sourceX = targetX % srcWidth
        const sourceY = targetY % srcHeight
        // 计算偏移量
        const sourceOffset = (sourceY * srcWidth + sourceX) * 4
        const targetOffset = (targetY * targetWidth + targetX) * 4
        // 复制 RGBA 4 个字节
        targetPixels[targetOffset] = sourcePixels[sourceOffset]         // R
        targetPixels[targetOffset + 1] = sourcePixels[sourceOffset + 1] // G
        targetPixels[targetOffset + 2] = sourcePixels[sourceOffset + 2] // B
        targetPixels[targetOffset + 3] = sourcePixels[sourceOffset + 3] // A
      }
    }
    const initOpts: image.InitializationOptions = {
      size: { width: targetWidth, height: targetHeight },
      pixelFormat: image.PixelMapFormat.RGBA_8888
    }
    const targetPixelMap = await image.createPixelMap(targetBuffer, initOpts)
    sourcePixelMap.release()
    return targetPixelMap
  }
}

export { CompleteImageAdapter }