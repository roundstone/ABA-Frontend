"use client";

import React, { useState } from 'react';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { reviewSchema, ReviewFormValues } from '../schemas';
import { useSubmitProductReview } from '../mutations';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Star, ImagePlus, X } from 'lucide-react';

interface ReviewFormProps {
  productId: string;
  variantBought?: string;
  onSuccess?: () => void;
  onCancel?: () => void;
}

export function ReviewForm({ productId, variantBought, onSuccess, onCancel }: ReviewFormProps) {
  const submitReview = useSubmitProductReview();
  const [photos, setPhotos] = useState<string[]>([]);
  const [photoInput, setPhotoInput] = useState('');

  const {
    register,
    handleSubmit,
    control,
    setValue,
    watch,
    formState: { errors, isValid }
  } = useForm<ReviewFormValues>({
    resolver: zodResolver(reviewSchema),
    defaultValues: {
      rating: 0,
      title: '',
      body: '',
      photos: []
    }
  });

  const currentRating = watch('rating');

  const addPhoto = () => {
    if (photoInput && photos.length < 3) {
      const updated = [...photos, photoInput];
      setPhotos(updated);
      setValue('photos', updated);
      setPhotoInput('');
    }
  };

  const removePhoto = (index: number) => {
    const updated = photos.filter((_, i) => i !== index);
    setPhotos(updated);
    setValue('photos', updated);
  };

  const onSubmit = (data: ReviewFormValues) => {
    submitReview.mutate(
      { productId, data: { ...data, variantBought } },
      {
        onSuccess: () => {
          if (onSuccess) onSuccess();
        }
      }
    );
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-6 bg-white p-6 rounded-lg border">
      <div className="space-y-2">
        <h3 className="text-lg font-semibold">Write a Review</h3>
        {variantBought && (
          <p className="text-sm text-muted-foreground">For: {variantBought}</p>
        )}
      </div>

      <div className="space-y-2">
        <label className="text-sm font-medium">Rating *</label>
        <Controller
          name="rating"
          control={control}
          render={({ field }) => (
            <div className="flex items-center gap-1">
              {[1, 2, 3, 4, 5].map((star) => (
                <button
                  type="button"
                  key={star}
                  onClick={() => field.onChange(star)}
                  className="p-1 focus:outline-none"
                >
                  <Star
                    className={`w-8 h-8 ${star <= field.value ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300 hover:text-yellow-200'}`}
                  />
                </button>
              ))}
            </div>
          )}
        />
        {errors.rating && <p className="text-sm text-red-500">{errors.rating.message}</p>}
      </div>

      <div className="space-y-2">
        <label htmlFor="title" className="text-sm font-medium">Title (Optional)</label>
        <Input 
          id="title" 
          placeholder="Sum up your experience" 
          {...register('title')} 
        />
        {errors.title && <p className="text-sm text-red-500">{errors.title.message}</p>}
      </div>

      <div className="space-y-2">
        <label htmlFor="body" className="text-sm font-medium">Review *</label>
        <textarea
          id="body"
          className={`w-full min-h-[120px] p-3 text-sm border rounded-md ${errors.body ? 'border-red-500' : 'border-input'}`}
          placeholder="What did you like or dislike? (minimum 20 characters)"
          {...register('body')}
        />
        <div className="flex justify-between text-xs text-muted-foreground">
          {errors.body ? (
            <span className="text-red-500">{errors.body.message}</span>
          ) : (
            <span>Minimum 20 characters</span>
          )}
        </div>
      </div>

      <div className="space-y-2">
        <label className="text-sm font-medium">Photos (Optional, max 3)</label>
        {photos.length < 3 && (
          <div className="flex items-center gap-2">
            <Input 
              value={photoInput} 
              onChange={e => setPhotoInput(e.target.value)} 
              placeholder="Paste image URL here" 
              className="flex-1"
            />
            <Button type="button" variant="outline" onClick={addPhoto}>
              <ImagePlus className="w-4 h-4 mr-2" /> Add
            </Button>
          </div>
        )}
        {photos.length > 0 && (
          <div className="flex gap-2 mt-2">
            {photos.map((url, idx) => (
              <div key={idx} className="relative w-20 h-20 border rounded overflow-hidden group">
                <img src={url} alt="Upload preview" className="object-cover w-full h-full" />
                <button
                  type="button"
                  onClick={() => removePhoto(idx)}
                  className="absolute top-1 right-1 bg-black/50 text-white p-1 rounded-full opacity-0 group-hover:opacity-100 transition-opacity"
                >
                  <X className="w-3 h-3" />
                </button>
              </div>
            ))}
          </div>
        )}
        {errors.photos && <p className="text-sm text-red-500">{errors.photos.message}</p>}
      </div>

      <div className="flex justify-end gap-3 pt-4 border-t">
        {onCancel && (
          <Button type="button" variant="ghost" onClick={onCancel}>
            Cancel
          </Button>
        )}
        <Button type="submit" disabled={!isValid || currentRating === 0 || submitReview.isPending}>
          Submit Review
        </Button>
      </div>
    </form>
  );
}
